//
//  Config.h
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
{
    // 最後に起動したときのバージョン
    NSString *mLastLaunchedVersion;
    
    NSString *mMessage1;
    NSString *mMessage2;
    NSString *mMessage3;
    
    BOOL mIsUseEmail;
    NSString *mEmailAddress;
    
    BOOL mIsUseTwitter;
    BOOL mIsUseDirectMessage;
    NSString *mTwitterAddress;
    
    NSString *mTwitterOAuthToken;
    NSString *mTwitterOAuthSecret;
}

@property(nonatomic, strong) NSString *message1;
@property(nonatomic, strong) NSString *message2;
@property(nonatomic, strong) NSString *message3;

@property(nonatomic) BOOL isUseEmail;
@property(nonatomic, strong) NSString *emailAddress;

@property(nonatomic) BOOL isUseTwitter;
@property(nonatomic) BOOL isUseDirectMessage;
@property(nonatomic, strong) NSString *twitterAddress;

@property(nonatomic, strong) NSString *twitterOAuthToken;
@property(nonatomic, strong) NSString *twitterOAuthSecret;

+ (Config *)instance;
- (void)save;

@end
