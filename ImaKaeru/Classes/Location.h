// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

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
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL hasLocation;
@property (NS_NONATOMIC_IOSONLY, getter=getLocationUrl, readonly, copy) NSString *locationUrl;

@end
