// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import "Location.h"

@implementation Location

@synthesize delegate = mDelegate;

- (id)init
{
    self = [super init];
    if (self) {
        mLocationManager = [[CLLocationManager alloc] init];
        mLocationManager.delegate = self;
        mLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        mLocationManager.distanceFilter = 100;
    }
    return self;
}

- (void)dealloc
{
    if (mLocationManager != nil) {
        mLocationManager.delegate = nil;
        mLocationManager = nil;
    }
}

- (void)startUpdating
{
    if (mLocationManager.location == nil) {
        // stop させて、強制的にイベントを発生させる
        [mLocationManager stopUpdatingLocation];
    }

    [mLocationManager startUpdatingLocation];
}

- (void)stopUpdating
{
    [mLocationManager stopUpdatingLocation];
}

- (BOOL)hasLocation
{
    if (mLocationManager.location != nil) {
        return YES;
    }
    return NO;
}

- (CLLocation *)location
{
    return mLocationManager.location;
}

- (NSString *)getLocationUrl
{
    if (mLocationManager.location == nil) {
        return nil;
    }

    CLLocation *loc = mLocationManager.location;
    NSString *url = [NSString stringWithFormat:@"http://maps.google.com?q=%.4f,%.4f",
                              loc.coordinate.latitude, loc.coordinate.longitude];
    return url;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    NSLog(@"success to get location");
    [mDelegate location:self didUpdate:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"failed to get location");
    [mDelegate location:self didFail:error];
}

@end
