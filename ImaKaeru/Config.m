//
//  Config.m
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Config.h"

@interface Config ()
- (void)firstStartup;
- (void)load;
- (void)save;
@end

@implementation Config

@synthesize message1 = mMessage1;
@synthesize message2 = mMessage2;
@synthesize message3 = mMessage3;

@synthesize isUseEmail = mIsUseEmail;
@synthesize emailAddress = mEmailAddress;

static Config *theInstance = nil;

+ (Config *)instance
{
    if (theInstance == nil) {
        theInstance = [Config new];
    }
    return theInstance;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    mLastLaunchedVersion = [defaults stringForKey:@"LastLaunchedVersion"];
    if (mLastLaunchedVersion == nil) {
        // First startup
        [self firstStartup];
    } else {
        [self load];
    }
    
    return self;
}

- (void)firstStartup
{
    mMessage1 = @"今からかえります";
    mMessage2 = @"もう少ししたら帰ります";
    mMessage3 = @"遅くなるかも";
    
    mIsUseEmail = YES;
    
    // FOR INTERNAL TEST
    mEmailAddress = @"tmurakam@tmurakam.org";
    
    [self save];
}

- (void)load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    mIsUseEmail = [defaults boolForKey:@"IsUseEmail"];
    mEmailAddress = [defaults stringForKey:@"EmailAddress"];
}

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:mMessage1 forKey:@"Message1"];
    [defaults setObject:mMessage2 forKey:@"Message2"];
    [defaults setObject:mMessage3 forKey:@"Message3"];    
    
    [defaults setBool:mIsUseEmail forKey:@"IsUseEmail"];
    [defaults setObject:mEmailAddress forKey:@"EmailAddress"];
    
    // TODO: save current version
    //[defaults setObject:@"1.0" forKey:@"LastLaunchedVersion"];

    [defaults synchronize];
}

@end
