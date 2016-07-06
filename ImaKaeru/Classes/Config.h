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
    
    //BOOL mIsUseTwitter;
    //BOOL mIsUseDirectMessage;
    //NSString *mTwitterAddress;
    
    BOOL mIsFirstStartup;
    BOOL mIsVersionUp;
}

@property(strong) NSString *message1;
@property(strong) NSString *message2;
@property(strong) NSString *message3;

@property BOOL isSendLocation;

@property BOOL isUseEmail;
@property(strong) NSString *emailAddress;

//@property BOOL isUseTwitter;
//@property BOOL isUseDirectMessage;
//@property(strong) NSString *twitterAddress;

@property BOOL isFirstStartup;
@property BOOL isVersionUp;

+ (Config *)instance;
- (void)save;

@end
