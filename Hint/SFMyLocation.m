//
//  SFMyLocation.m
//  TryingMap
//
//  Created by 孙培峰 on 4/21/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "SFMyLocation.h"
#import <AddressBook/AddressBook.h>

@interface SFMyLocation ()

@end

@implementation SFMyLocation
@synthesize title = _title;

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"%@",name);

    self = [super init];
    if ([name isKindOfClass:[NSString class]])
    {
        self.name = name;
    }
    else
    {
        self.name = @"TA 的位置";
    }
    self.theCoordinate = coordinate;
    return self;


}

- (NSString *)title
{
    return self.name;
}


- (CLLocationCoordinate2D)coordinate
{
    return self.theCoordinate;
}

- (MKMapItem*)mapItem
{
    MKPlacemark *placemark = [[MKPlacemark alloc]initWithCoordinate:self.coordinate addressDictionary:nil];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
