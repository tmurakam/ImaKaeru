//
//  ViewController.h
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <iAd/iAd.h>
#import <CoreLocation/CoreLocation.h>

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

#import "Config.h"

@interface MainViewController : UIViewController <MFMailComposeViewControllerDelegate, ADBannerViewDelegate, CLLocationManagerDelegate>
{
    Config *mConfig;
    
    IBOutlet UIButton *mSendButton1;
    IBOutlet UIButton *mSendButton2;
    IBOutlet UIButton *mSendButton3;
    
    IBOutlet UIButton *mEmailButton;
    IBOutlet UIButton *mTwitterButton;
    
    IBOutlet UIButton *mConfigButton;
    
    IBOutlet ADBannerView *mAdBannerView;
    
    NSString *mMessageToSend;

    int mStatus;

    CLLocationManager *mLocationManager;
    BOOL mHasLocation;
    double mLatitude;
    double mLongitude;
}

- (IBAction)onPushSendMessage:(id)sender;
- (IBAction)showConfigViewController:(id)sender;

- (IBAction)onToggleEmailButton:(id)sender;
- (IBAction)onToggleTwitterButton:(id)sender;

- (void)updateButtonStates;
- (void)startSend;
- (BOOL)sendEmail;
- (BOOL)sendTwitter;

- (void)showMessage:(NSString *)message title:(NSString *)title;
- (void)showError:(NSString *)message;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (void)tweetDone;
- (void)tweetFailed:(NSString *)statusMessage;

- (void)showHideBanner;


@end
