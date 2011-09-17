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

#import "Config.h"

@interface MainViewController : UIViewController <MFMailComposeViewControllerDelegate, ADBannerViewDelegate>
{
    Config *mConfig;
    
    IBOutlet UIButton *mSendButton1;
    IBOutlet UIButton *mSendButton2;
    IBOutlet UIButton *mSendButton3;
}

- (IBAction)onPushSendMessage:(id)sender;
- (IBAction)showConfigViewController:(id)sender;
- (IBAction)showInfoViewController:(id)sender;

- (void)sendEmail:(NSString *)message;
//- (void)sendTwitter;

@end
