//
//  SFMapViewController.m
//  Hint
//
//  Created by 孙培峰 on 5/25/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

@import MapKit;
@import CoreLocation;
@import UIKit;
#import "SFMapViewController.h"
#import "SFMyLocation.h"

@interface SFMapViewController ()<MKMapViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backToCurrentPositionButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property CLLocationCoordinate2D myCoordinate;
@property CLLocationCoordinate2D selectedVehicleCoordinate;
@property (strong, nonatomic) UIAlertView *locationServiceAlertView;
@property (strong, nonatomic) UIAlertView *networkAlertView;
@property (strong, nonatomic) NSMutableArray *vehiclesPositionDictionariesArray;
//@property (strong, nonatomic) UIButton *viewVehiclePositionButton;
@property (weak, nonatomic) IBOutlet UIButton *viewVehiclePositionButton;
@property (strong, nonatomic) NSString *selectedVehicleName;
@property NSUInteger selectedRowNumber;
@property (strong, nonatomic) NSMutableArray *vehicleAnnotationsArray;

@end

@implementation SFMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _vehiclesPositionDictionariesArray = [[NSMutableArray alloc]init];
    _vehicleAnnotationsArray = [[NSMutableArray alloc]init];

    [self setupMapView];

    [self setupViewVehiclePositionButton];

    [self fetchCarsPosition];
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        [self.view bringSubviewToFront:self.viewVehiclePositionButton];
        [self.view bringSubviewToFront:self.backToCurrentPositionButton];
    }];

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = userLocation.coordinate;
    _myCoordinate = userLocation.coordinate;

    if (_myCoordinate.latitude == 0)
    {
        [self showAlertViewForLocationService];
    }
    else if(_myCoordinate.latitude != 0 && _locationServiceAlertView != nil)
    {
        [self dismissAlertViewForLocationService];
    }

    [self showCurrentPosition];
}

- (IBAction)backToCurrentPosition:(id)sender
{
    [self showCurrentPosition];
}

- (IBAction)showPositionOfSelectedVehicle:(id)sender
{
    [self showPositionOfSelectedVehicle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchCarsPosition
{
    NSString *urlString = [NSString stringWithFormat:@"http://abcd.ziqiang.net/bus/userreceive/"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];

    NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data == nil)
         {
             NSLog(@"Returned NIL Data!");
             [self showAlertViewForNetwork];
         }
         else
         {
             _vehiclesPositionDictionariesArray = [self serializingJsonDataToArrayContainingDictionary:data];
             [self putAnnotationOnMapFromArrayContainingDictionary:_vehiclesPositionDictionariesArray];
             static BOOL isFirstLoad = YES;

                 if (isFirstLoad == YES)
                 {
                     _viewVehiclePositionButton.titleLabel.text = [NSString stringWithFormat:@"看看%@的车去",[[_vehiclesPositionDictionariesArray objectAtIndex:0] objectForKey:@"bus_name"]];
                 }
                 isFirstLoad = NO;
                 if (_selectedVehicleCoordinate.latitude != 0)
                 {
                     [self showPositionOfSelectedVehicle];
                 }
             }
     }];
     }



#pragma mark Config PickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _vehiclesPositionDictionariesArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[_vehiclesPositionDictionariesArray objectAtIndex:row] objectForKey:@"bus_name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *item = [self pickerView:pickerView titleForRow:row forComponent:component];
    _selectedVehicleName = item;
    _selectedRowNumber = row;
    [_viewVehiclePositionButton setTitle:[NSString stringWithFormat:@"看看%@的车去" ,item] forState:UIControlStateNormal];
}





#pragma mark DequeueReusableAnnotationView

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"pin";
    if (annotation == mapView.userLocation)
    {
        //returning nil means 'use built in location view'
        return nil;
    }

    MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (pinAnnotation == nil)
    {
        pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    else
    {
        pinAnnotation.annotation = annotation;
    }
    pinAnnotation.canShowCallout = YES;
    pinAnnotation.pinColor = MKPinAnnotationColorPurple;
    pinAnnotation.animatesDrop = YES;

    return pinAnnotation;

}


#pragma mark ConfiggingKits

- (void)setupMapView
{
    _mapView.showsUserLocation=YES;
    _mapView.delegate = self;
    _mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    [self.view addSubview:_mapView];
    //    [self.view bringSubviewToFront:_backToCurrentPositionButton];
}



- (void)showAlertViewForLocationService
{
    _locationServiceAlertView = [[UIAlertView alloc]initWithTitle:@"正在获取数据...请等待"
                                                          message:@"若等待时间过长，请检查定位服务是否打开"
                                                         delegate:nil
                                                cancelButtonTitle:@"知道啦"
                                                otherButtonTitles:nil];
    [_locationServiceAlertView show];
}

- (void)showAlertViewForNetwork
{
    _networkAlertView = [[UIAlertView alloc]initWithTitle:@"正在等待网络连接数据"
                                                  message:@"网络貌似不太乖，如果等待时间过长请检查它\n( ˘•ω•˘ )"
                                                 delegate:nil
                                        cancelButtonTitle:@"知道啦"
                                        otherButtonTitles:nil];
    [_networkAlertView show];
}

- (void)dismissAlertViewForLocationService
{
    [_locationServiceAlertView dismissWithClickedButtonIndex:0 animated:YES];
    _locationServiceAlertView = nil;
}

- (void)showMapViewWithinRegion:(CLLocationCoordinate2D)centerCoordinate latitudinalMeters:(CLLocationDistance)latitudinalMeters longitudinalMeters:(CLLocationDistance)longitudinalMeters
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoordinate, latitudinalMeters, longitudinalMeters);
    [self.mapView setRegion:region animated:YES];
}

- (void)showMapViewWithCenter:(CLLocationCoordinate2D)centerCoordinate
{
    [self showMapViewWithinRegion:centerCoordinate latitudinalMeters:500 longitudinalMeters:500];
}

- (void)showCurrentPosition
{
    [self showMapViewWithinRegion:_myCoordinate latitudinalMeters:500 longitudinalMeters:500];
}

- (NSMutableArray *)serializingJsonDataToArrayContainingDictionary:(NSData *)data
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]];

    NSMutableDictionary *dic1 = [dic objectForKey:@"position"];
    NSMutableArray *vehiclesPositionDictionariesArray = [[NSMutableArray alloc]init];
    for (id vehiclesInfo in dic1)
    {
        [vehiclesPositionDictionariesArray addObject:vehiclesInfo];
    }
    return vehiclesPositionDictionariesArray;
}

- (void)putAnnotationOnMapFromArrayContainingDictionary:(NSMutableArray *)arrayContainingDictionary
{
    for (id vehicleInfoDic in arrayContainingDictionary)
    {
        if ([[vehicleInfoDic objectForKey:@"bus_name"] isEqualToString:@""])
        {
            [arrayContainingDictionary removeObject:vehicleInfoDic];
            return;
        }
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[vehicleInfoDic objectForKey:@"latitude"] doubleValue], [[vehicleInfoDic objectForKey:@"longitude"] doubleValue]);
        NSLog(@"latitude:%f,longitude:%f,%@",location.latitude,location.longitude,[vehicleInfoDic objectForKey:@"bus_name"]);
        SFMyLocation *locationForAnnotation = [[SFMyLocation alloc]initWithName:[vehicleInfoDic objectForKey:@"bus_name"] coordinate:location];
        [_vehicleAnnotationsArray addObject:locationForAnnotation];
        NSLog(@"bus_name:  %@",[vehicleInfoDic objectForKey:@"bus_name"]);
        [_mapView addAnnotation:locationForAnnotation];
    }
}

- (void)showCurrentPosition:(id)sender
{
    [self showCurrentPosition];
}

- (void)showPositionOfSelectedVehicle
{
    if (_selectedVehicleName != nil && ![_selectedVehicleName isEqual:@""])
    {
        for (NSMutableDictionary *posDicForSingleVehicle in _vehiclesPositionDictionariesArray)
        {
            if ([[posDicForSingleVehicle objectForKey:@"bus_name"] isEqualToString:_selectedVehicleName])
            {
                _selectedVehicleCoordinate = CLLocationCoordinate2DMake([[posDicForSingleVehicle objectForKey:@"latitude"] doubleValue], [[posDicForSingleVehicle objectForKey:@"longitude"] doubleValue]);
                break;
            }
        }
        [self showMapViewWithCenter:_selectedVehicleCoordinate];

        //TODO:这里问问老黄为什么加alloc，init会在三次之后Crash

        for (SFMyLocation *annotation in [_mapView annotations])
        {
            if ([annotation.name isEqual:_selectedVehicleName])
            {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    [self.mapView selectAnnotation:annotation animated:YES];
                }];
                break;
            }
        }

    }

}

- (void)setupViewVehiclePositionButton
{
    //    _viewVehiclePositionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_viewVehiclePositionButton setFrame:CGRectMake(120, 240, 200, 90)];
//    _viewVehiclePositionButton.titleLabel.text = @"送老夫看看车到哪儿了";
    //    [_viewVehiclePositionButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    //    [_viewVehiclePositionButton addTarget:self action:@selector(showPositionOfSelectedVehicle) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:_viewVehiclePositionButton];
}
@end