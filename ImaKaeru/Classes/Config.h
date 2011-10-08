// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import <Foundation/Foundation.h>
#import "Common.h"

@interface Config : NSObject
{
    // 最後に起動したときのバージョン
    NSString *mLastLaunchedVersion;
    
    NSString *mMessage1;
    NSString *mMessage2;
    NSString *mMessage3;

    BOOL mIsSendLocation;

    BOOL mIsUseEmail;
    NSString *mEmailAddress;
    
    BOOL mIsUseTwitter;
    BOOL mIsUseDirectMessage;
    NSString *mTwitterAddress;
    
    BOOL mIsFirstStartup;
    BOOL mIsVersionUp;
}

@property(nonatomic, strong) NSString *message1;
@property(nonatomic, strong) NSString *message2;
@property(nonatomic, strong) NSString *message3;

@property(nonatomic) BOOL isSendLocation;

@property(nonatomic) BOOL isUseEmail;
@property(nonatomic, strong) NSString *emailAddress;

@property(nonatomic) BOOL isUseTwitter;
@property(nonatomic) BOOL isUseDirectMessage;
@property(nonatomic, strong) NSString *twitterAddress;

@property(readonly) BOOL isFirstStartup;
@property(readonly) BOOL isVersionUp;

+ (Config *)instance;
- (void)save;

- (void)saveCurrentVersion;

@end
