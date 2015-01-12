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
        mLocationManager = [CLLocationManager new];
        mLocationManager.delegate = self;
        mLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
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
    // iOS8: 位置情報サービスの認証状態をチェックする
    if ([mLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                [mLocationManager requestWhenInUseAuthorization];
                return;
                
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                break;

            case kCLAuthorizationStatusDenied:
            case kCLAuthorizationStatusRestricted:
                // TODO:
                [mDelegate location:self didFail:nil];
                return;
        }
    }

    if (mLocationManager.location == nil) {
        // stop させて、強制的にイベントを発生させる
        [mLocationManager stopUpdatingLocation];
    }
    [mLocationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            //[mLocationManager requestWhenInUseAuthorization];
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [mLocationManager startUpdatingLocation];
            break;
            
        default:
            // TODO
            [mDelegate location:self didFail:nil];
            break;
    }
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"success to get location");
    [mDelegate location:self didUpdate:locations[0]];
}

/* 以下は iOS5 まで
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

    NSLog(@"success to get location");
    [mDelegate location:self didUpdate:newLocation];
}
*/

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"failed to get location");
    [mDelegate location:self didFail:error];
}



@end
