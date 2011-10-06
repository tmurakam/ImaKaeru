//
//  Location.h
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class Location;

@protocol LocationDelegate
- (void)location:(Location*)location didUpdate:(CLLocation *)location;
- (void)location:(Location*)location didFail:(NSError *)error;
@end

@interface Location : NSObject <CLLocationManagerDelegate>
{
    __weak id<LocationDelegate> mDelegate;

    CLLocationManager *mLocationManager;
}

@property(weak) id<LocationDelegate> delegate;
@property(readonly) CLLocation *location;

- (void)startUpdating;
- (void)stopUpdating;
- (BOOL)hasLocation;
- (NSString *)getLocationUrl;

@end
