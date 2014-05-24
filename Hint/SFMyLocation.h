//
//  SFMyLocation.h
//  TryingMap
//
//  Created by 孙培峰 on 4/21/14.
//  Copyright (c) 2014 孙培峰. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface SFMyLocation : NSObject<MKAnnotation>

@property CLLocationCoordinate2D theCoordinate;
@property (nonatomic, strong) NSString *name;

- (id)initWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate;

@end
