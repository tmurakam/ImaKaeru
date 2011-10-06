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
- (NSString *)currentVersion;
@end

@implementation Config

@synthesize message1 = mMessage1;
@synthesize message2 = mMessage2;
@synthesize message3 = mMessage3;

@synthesize isSendLocation = mIsSendLocation;

@synthesize isUseEmail = mIsUseEmail;
@synthesize emailAddress = mEmailAddress;

@synthesize isUseTwitter = mIsUseTwitter;
@synthesize isUseDirectMessage = mIsUseDirectMessage;
@synthesize twitterAddress = mTwitterAddress;

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
    mMessage1 = _L(@"im_on_my_way");
    mMessage2 = _L(@"ill_on_my_way_later");
    mMessage3 = _L(@"ill_be_late");
    
    mIsSendLocation = YES;

    mIsUseEmail = YES;
    mIsUseTwitter = YES;
    mIsUseDirectMessage = YES;
    
    [self save];
}

- (void)load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    mMessage1 = [defaults stringForKey:@"Message1"];
    mMessage2 = [defaults stringForKey:@"Message2"];
    mMessage3 = [defaults stringForKey:@"Message3"];
    
    mIsSendLocation = [defaults boolForKey:@"IsSendLocation"];

    mIsUseEmail = [defaults boolForKey:@"IsUseEmail"];
    mEmailAddress = [defaults stringForKey:@"EmailAddress"];
    
    mIsUseTwitter = [defaults boolForKey:@"IsUseTwitter"];
    mIsUseDirectMessage = [defaults boolForKey:@"IsUseDirectMessage"];
    mTwitterAddress = [defaults stringForKey:@"TwitterAddress"];
}

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:mMessage1 forKey:@"Message1"];
    [defaults setObject:mMessage2 forKey:@"Message2"];
    [defaults setObject:mMessage3 forKey:@"Message3"];    
    
    [defaults setBool:mIsSendLocation forKey:@"IsSendLocation"];

    [defaults setBool:mIsUseEmail forKey:@"IsUseEmail"];
    [defaults setObject:mEmailAddress forKey:@"EmailAddress"];
    
    [defaults setBool:mIsUseTwitter forKey:@"IsUseTwitter"];
    [defaults setBool:mIsUseDirectMessage forKey:@"IsUseDirectMessage"];
    [defaults setObject:mTwitterAddress forKey:@"TwitterAddress"];
    
    // save current version
    [defaults setObject:[self currentVersion] forKey:@"LastLaunchedVersion"];

    [defaults synchronize];
}

- (NSString *)currentVersion
{
    NSString *ver = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    return ver;
}

@end
