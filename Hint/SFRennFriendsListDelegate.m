//
//  SFRennFriendsListDelegate.m
//  Hint
//
//  Created by 孙培峰 on 3/28/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import "SFRennFriendsListDelegate.h"
//#import "SFRennFriendsListWithTag+ ListUserFriendParam.h"
#import "SBJSON.h"

#define kNumberOfPagesLoadEachTime 5
#define kPageSize 100

@protocol SFRennFriendsIconDelegate <NSObject>

//- (void)

@end


@interface SFRennFriendsListDelegate ()<NSURLSessionDelegate>

@property BOOL needToLoadAgain;
@property NSInteger timesFriendsListLoaded;
@property (strong, nonatomic) id <SFRennFriendsIconDelegate>rennFriendsIconDelegate;
@property (strong, nonatomic) NSURLSession *iconSession;

@end

@implementation SFRennFriendsListDelegate

- (id)init
{
    self = [super init];

    self.friendsListInfoArray = [[NSMutableArray alloc]init];
    self.lovedPeopleIDArray = [[NSMutableArray alloc]init];

    [self setupUrlSession];



    _needToLoadAgain = YES;
    _timesFriendsListLoaded = 0;
    self.hasIconLoadingFinished = NO;

    return self;
}

+ (instancetype)sharedManager
{
    static SFRennFriendsListDelegate *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}

- (void)loadListForTheTime:(NSInteger)timeLoaded
{
    static NSInteger i = 1;
    for (i = 1+kNumberOfPagesLoadEachTime*(timeLoaded-1); i <=  kNumberOfPagesLoadEachTime+kNumberOfPagesLoadEachTime*(timeLoaded-1); i++)
    {
        ListUserFriendParam *param = [[ListUserFriendParam alloc] init];
        param.userId = [RennClient uid];
        param.pageNumber = i;
        param.pageSize = kPageSize;

        //            以后需要时候直接导入头文件，改param的原始类为SFRennFriendsListWithTag+ ListUserFriendParam即可
        //            param.tag = @"1";
        [RennClient sendAsynRequest:param delegate:self];
    }

    _timesFriendsListLoaded++;
}

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    NSLog(@"requestSuccessWithResponse:%@", [[SBJSON new]  stringWithObject:response error:nil]);
    NSMutableArray *arrayForResponse = [[NSMutableArray alloc]init];
    arrayForResponse = response;
    static NSInteger timesProcessed = 0;
    timesProcessed++;
    if (arrayForResponse.count != 0)
    {
        [self serializingResponseArray:arrayForResponse];
    }

    if (arrayForResponse.count != kPageSize)
    {
        _needToLoadAgain = NO;
    }
    if (timesProcessed == kNumberOfPagesLoadEachTime*(_timesFriendsListLoaded))
    {
        [self checkWhetherNeedToLoadFriendsListAgain];
    }


}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    NSLog(@"requestFailWithError:%@", [error description]);
    NSString *domain = [error domain];
    NSString *code = [[error userInfo] objectForKey:@"code"];
    NSLog(@"requestFailWithError:Error Domain = %@, Error Code = %@", domain, code);
}

- (void)serializingResponseArray:(NSMutableArray *)arrayForResponse
{
    for (id singlePersonInfo in arrayForResponse)
    {
        NSMutableDictionary *friendInfoDictionary = [[NSMutableDictionary alloc]initWithObjects:@[@"name",@"iconImage",@"iconImageUrl",@"id"] forKeys:@[@"name",@"iconImage",@"iconImageUrl",@"id"]];
        [friendInfoDictionary setValue:[singlePersonInfo objectForKey:@"name"] forKey:@"name"];
        [friendInfoDictionary setValue:[NSString stringWithFormat:@"%@",[singlePersonInfo objectForKey:@"id"]] forKey:@"id"];
        NSArray *iconURLArray = [[NSArray alloc]initWithArray:[singlePersonInfo objectForKey:@"avatar"]];
        for (NSDictionary *singlePersonIconArray in iconURLArray)
        {
            if ([[singlePersonIconArray objectForKey:@"size"] isEqualToString:@"HEAD"])
            {
                [friendInfoDictionary setValue:[singlePersonIconArray objectForKey:@"url"] forKey:@"iconImageUrl"];
            }
        }
        [self.friendsListInfoArray addObject:friendInfoDictionary];
    }

}

- (void)checkWhetherNeedToLoadFriendsListAgain
{
    if (_needToLoadAgain == YES)
    {
        [self loadListForTheTime:_timesFriendsListLoaded+1];
    }
    else
    {
        NSLog(@"结束啦！");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadTableViewData" object:nil];
        [self loadFriendsIcon];
    }
}

- (void)loadFriendsIcon
{
    NSMutableArray *iconImagesArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<self.friendsListInfoArray.count ;i++)
    {
        iconImagesArray[i] = [NSNull null];
    }
    NSMutableArray *iconUrlArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<self.friendsListInfoArray.count ;i++)
    {
        [iconUrlArray addObject:[self.friendsListInfoArray[i] objectForKey:@"iconImageUrl"]];
    }
    for (NSString *iconUrlString in iconUrlArray)
    {
        NSURL *url = [NSURL URLWithString:iconUrlString];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"GET"];
        NSURLSessionDataTask * dataTask = [self.iconSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
        {
            if(error == nil)
            {
                static NSInteger iconLoaded = 0;
                NSLog(@"response.URL:%@",response.URL);

                for (NSMutableDictionary *personInfo in self.friendsListInfoArray)
                {
                    if ([[personInfo objectForKey:@"iconImageUrl"] isEqualToString:[response.URL absoluteString]])
                    {
                        [personInfo setValue:[SFRennFriendsListDelegate createRoundedRectImage:[UIImage imageWithData:data] size:CGSizeMake(63, 63)] forKey:@"iconImage"];
                    }
                }
                iconLoaded++;
                NSLog(@"Icon Loaded: %ld",(long)iconLoaded);

                if (iconLoaded >= self.friendsListInfoArray.count)
                {
                    for (NSInteger i = 0; i<self.friendsListInfoArray.count ;i++)
                    {
                        if ([self.friendsListInfoArray[i] objectForKey:@"iconImage"]  == [NSNull null])
                        {
                            [iconImagesArray replaceObjectAtIndex:i withObject:[UIImage imageNamed:@"1"]];
                        }
                    }
                    self.hasIconLoadingFinished = YES;

//                    for (NSInteger i = 0; i<self.friendsListInfoArray.count ; i++)
//                    {
//                        NSMutableArray *roundIconImagesArray = [[NSMutableArray alloc]init];
//                        [roundIconImagesArray addObject:[SFRennFriendsListDelegate createRoundedRectImage:[self.friendsListInfoArray[i] objectForKey:@"iconImage"] size:CGSizeMake(63, 63)]];
//                        [self.friendsListInfoArray[i] objectForKey:@"iconImage"] = roundIconImagesArray[0];
//                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"iconsLoadingFinished" object:nil];
                    
                }
            }
        }];
        [dataTask resume];

    }
}








#pragma mark Config Kits

- (void)setupUrlSession
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 15;
    self.iconSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
}





static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;

    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right

    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;

    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);

    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 33, 33);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}





@end
