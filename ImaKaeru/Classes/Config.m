// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import "Config.h"

@interface Config ()
- (void)firstStartup;
- (void)load;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *currentVersion;
@end

@implementation Config

@synthesize message1 = mMessage1;
@synthesize message2 = mMessage2;
@synthesize message3 = mMessage3;

@synthesize isSendLocation = mIsSendLocation;

@synthesize isUseEmail = mIsUseEmail;
@synthesize emailAddress = mEmailAddress;

//@synthesize isUseTwitter = mIsUseTwitter;
//@synthesize isUseDirectMessage = mIsUseDirectMessage;
//@synthesize twitterAddress = mTwitterAddress;

@synthesize isFirstStartup = mIsFirstStartup;
@synthesize isVersionUp = mIsVersionUp;

static Config *theInstance = nil;

+ (Config *)instance
{
    if (theInstance == nil) {
        theInstance = [Config new];
    }
    return theInstance;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    mLastLaunchedVersion = [defaults stringForKey:@"LastLaunchedVersion"];

    NSString *currentVersion = [self currentVersion];
    
    if (mLastLaunchedVersion == nil) {
        // First startup
        mIsFirstStartup = YES;
        [self firstStartup];
    } else {
        [self load];

        if (![mLastLaunchedVersion isEqualToString:[self currentVersion]]) {
            // version up
            mIsVersionUp = YES;
        }
    }
    
    if (mIsFirstStartup || mIsVersionUp) {
        [defaults setObject:currentVersion forKey:@"LastLaunchedVersion"];
        [defaults synchronize];
    }
    
    return self;
}

- (void)firstStartup
{
    mMessage1 = _L(@"im_on_my_way");
    mMessage2 = _L(@"ill_on_my_way_later");
    mMessage3 = _L(@"ill_be_late");
    
    mIsSendLocation = NO;

    mIsUseEmail = YES;
    //mIsUseTwitter = YES;
    //mIsUseDirectMessage = YES;
    
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
    
    //mIsUseTwitter = [defaults boolForKey:@"IsUseTwitter"];
    //mIsUseDirectMessage = [defaults boolForKey:@"IsUseDirectMessage"];
    //mTwitterAddress = [defaults stringForKey:@"TwitterAddress"];
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
    
    //[defaults setBool:mIsUseTwitter forKey:@"IsUseTwitter"];
    //[defaults setBool:mIsUseDirectMessage forKey:@"IsUseDirectMessage"];
    //[defaults setObject:mTwitterAddress forKey:@"TwitterAddress"];

    [defaults synchronize];
}

- (NSString *)currentVersion
{
    NSString *ver = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleShortVersionString"];
    return ver;
}

@end
