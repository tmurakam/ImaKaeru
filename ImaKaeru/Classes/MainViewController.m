//
//  ViewController.m
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "ConfigViewController.h"
#import "Common.h"

#import "TwitterSecret.h"

@implementation MainViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *whiteButton = [[UIImage imageNamed:@"whiteButton"] stretchableImageWithLeftCapWidth:16 topCapHeight:16];
    //[mSendButton1 setBackgroundImage:whiteButton forState:UIControlStateNormal];
    //[mSendButton2 setBackgroundImage:whiteButton forState:UIControlStateNormal];
    //[mSendButton3 setBackgroundImage:whiteButton forState:UIControlStateNormal];
    [mConfigButton setBackgroundImage:whiteButton forState:UIControlStateNormal];
    
    // iAd を画面外に移動
    CGRect frame;
    frame.size = mAdBannerView.frame.size;
    frame.origin = CGPointMake(0.0f, CGRectGetMaxY(self.view.bounds));
    mAdBannerView.frame = frame;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateButtonStates];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Handlers

// ボタン状態を更新する
- (void)updateButtonStates
{
    mConfig = [Config instance];
    
    [mSendButton1 setTitle:mConfig.message1 forState:UIControlStateNormal];
    [mSendButton2 setTitle:mConfig.message2 forState:UIControlStateNormal];
    [mSendButton3 setTitle:mConfig.message3 forState:UIControlStateNormal];
    
    //[mConfigButton setTitle:_L(@"config") forState:UIControlStateNormal];
    
    BOOL sendEnabled = YES;
    if (!mConfig.isUseEmail && !mConfig.isUseTwitter) {
        sendEnabled = NO;
    }
    mSendButton1.enabled = sendEnabled;
    mSendButton2.enabled = sendEnabled;
    mSendButton3.enabled = sendEnabled;
    
    mEmailButton.selected = mConfig.isUseEmail;
    mTwitterButton.selected = mConfig.isUseTwitter;    
}

// メッセージ送信
- (IBAction)onPushSendMessage:(id)sender
{
    // sanity check
    if (!mConfig.isUseEmail && !mConfig.isUseTwitter) {
        [self showError:_L(@"error_no_dest")];
        return;
    }
    else if (mConfig.isUseEmail && (mConfig.emailAddress == nil || [mConfig.emailAddress length] == 0)) {
        [self showError:_L(@"error_no_email_dest")];
        return;
    }
    if (mConfig.isUseTwitter && (mConfig.twitterAddress == nil || [mConfig.twitterAddress length] == 0)) {
        [self showError:_L(@"error_no_twitter_dest")];
        return;
    }
    
    if (sender == mSendButton1) {
        mMessageToSend = mConfig.message1;
    }
    else if (sender == mSendButton2) {
        mMessageToSend = mConfig.message2;
    }
    else if (sender == mSendButton3) {
        mMessageToSend = mConfig.message3;
    }
    
    // 送信する
    // Twitter とメール同時送信の場合は、Twitter送信が完了してからメール送信する
    if (mConfig.isUseTwitter) {
        [self sendTwitter];
    }
    else if (mConfig.isUseEmail) {
        [self sendEmail];
    }
}

- (IBAction)showConfigViewController:(id)sender
{
    ConfigViewController *vc = [[ConfigViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentModalViewController:nv animated:YES];
}

- (IBAction)onToggleTwitterButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    mConfig.isUseTwitter = !button.selected;
    [mConfig save];
    
    [self updateButtonStates];
}

- (IBAction)onToggleEmailButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    mConfig.isUseEmail = !button.selected;
    [mConfig save];
    
    [self updateButtonStates];
}

- (void)showMessage:(NSString *)message title:(NSString *)title
{
    UIAlertView *v = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:_L(@"dismiss") otherButtonTitles:nil];
    [v show];
}

- (void)showError:(NSString *)message
{
    [self showMessage:message title:_L(@"error")];
}

#pragma mark - Email
- (void)sendEmail
{
    if (![MFMailComposeViewController canSendMail]) {
        // TBD
        return;
    }
    
    MFMailComposeViewController *vc = [MFMailComposeViewController new];
    vc.mailComposeDelegate = self;
    
    [vc setToRecipients:[NSArray arrayWithObject:mConfig.emailAddress]];
    [vc setSubject:mMessageToSend]; // TBD
    
    NSMutableString *body = [NSMutableString stringWithString:mMessageToSend];
    [body appendString:@"\n\n"];
    [body appendFormat:@"Sent from %@\nhttp://iphone.tmurakam.org/ImaKaeru", _L(@"app_name")];
    [vc setMessageBody:body isHTML:NO];
    
    [self presentModalViewController:vc animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - Twitter

- (void)sendTwitter
{
    if (mConfig.twitterAddress == nil || [mConfig.twitterAddress length] == 0) {
        // TODO: 宛先なし
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *apiUrl;

    NSString *msg;
    if (mConfig.isUseDirectMessage) {
	// DirectMessage
	apiUrl = @"http://api.twitter.com/1/direct_messages/new.json";

	msg = [NSString stringWithFormat:@"%@ %@ http://iphone.tmurakam.org/ImaKaeru", mMessageToSend, _L(@"hash_tag")];
	[params setObject:msg forKey:@"text"];
	[params setObject:mMessageToSend forKey:@"user_id"];
    } else {
	// mention
	apiUrl = @"http://api.twitter.com/1/statuses/update.json";

	msg = [NSString stringWithFormat:@"@%@ %@ %@ http://iphone.tmurakam.org/ImaKaeru", mConfig.twitterAddress, mMessageToSend, _L(@"hash_tag")];
	[params setObject:msg forKey:@"text"];
    }

    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [store requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if (!granted) {
	    // TBD : エラー
	    [self showError:_L(@"error_setup_twitter_account")];
	    return;
	}
	NSArray *accounts = [store accountsWithAccountType:accountType];
	if ([accounts count] <= 0) {
	    // TBD: エラー、アカウントなし
	    [self showError:_L(@"error_setup_twitter_account")];
	}
	
	ACAccount *account = [accounts objectAtIndex:0];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	// request 作成
	TWRequest *req = [[TWRequest alloc] initWithURL:[NSURL URLWithString:apiUrl]
					     parameters:params
					  requestMethod:TWRequestMethodPOST];
	[req setAccount:account];
	[req performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
		if ([urlReponse statusCode] == 200) {
		    [self performSelectorOnMainThread:@selector(tweetDone) withObject:nil waitUntilDone:NO];
		} else {
		    [self performSelectorOnMainThread:@selector(tweetFailed) withObject:nil waitUntilDone:NO];
		}
	    }];
	}];
}

- (void)tweetDone
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if (mConfig.isUseEmail) {
        [self sendEmail];
    } else {
        [self showMessage:_L(@"tweet_completed") title:@"Twitter"];
    }

}

- (void)tweetFailed
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self showError:_L(@"tweet_failed")];
}

#pragma mark - ADBannerViewDelegate

- (void)showHideBanner
{
    CGRect frame;
    frame.size = mAdBannerView.frame.size;
    frame.origin = CGPointMake(0, CGRectGetMaxY(self.view.bounds));
    
    if (mAdBannerView.bannerLoaded) {
        frame.origin.y -= mAdBannerView.frame.size.height;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        mAdBannerView.frame = frame;
    }];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"iAd loaded");
    [self showHideBanner];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAd load failed");
    [self showHideBanner];
}

@end
