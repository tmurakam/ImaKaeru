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
    NSString *mTwitterAddress;
}

@property(nonatomic, retain) NSString *message1;
@property(nonatomic, retain) NSString *message2;
@property(nonatomic, retain) NSString *message3;
@property(nonatomic, assign) BOOL isUseEmail;
@property(nonatomic, retain) NSString *emailAddress;

+ (Config *)instance;
- (void)save;

@end
