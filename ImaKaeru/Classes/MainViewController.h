// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <iAd/iAd.h>

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

#import "Config.h"
#import "Location.h"

// ステート
typedef enum {
    StIdle = 0,     // アイドル中
    StGetLocation,  // 送信前位置取得中
    StSending,      // 送信中
} State;

@interface MainViewController : UIViewController <MFMailComposeViewControllerDelegate, ADBannerViewDelegate, LocationDelegate>
{
    Config *mConfig;
    
    IBOutlet UIButton *mSendButton1;
    IBOutlet UIButton *mSendButton2;
    IBOutlet UIButton *mSendButton3;
    
    IBOutlet UIButton *mEmailButton;
    IBOutlet UIButton *mTwitterButton;
    
    IBOutlet UIButton *mConfigButton;
    
    IBOutlet ADBannerView *mAdBannerView;
    
    // 送信したいメッセージ
    NSString *mMessageToSend;

    // 送信状態
    State mState;

    // 位置取得用
    Location *mLocation;
}

@property(assign) State state;

- (IBAction)onPushSendMessage:(id)sender;

- (IBAction)onToggleEmailButton:(id)sender;
- (IBAction)onToggleTwitterButton:(id)sender;

- (void)updateButtonStates;
- (void)startSend;

- (BOOL)sendEmail;
- (BOOL)sendTwitter;

- (void)showMessage:(NSString *)message title:(NSString *)title;
- (void)showError:(NSString *)message;

- (void)tweetDone;
- (void)tweetFailed:(NSString *)statusMessage;

- (void)showHideBanner;


@end
