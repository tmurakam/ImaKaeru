// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import "MainViewController.h"
#import "ConfigViewController.h"
#import "InfoViewController.h"
#import "Common.h"

#define APP_URL @"http://iphone.tmurakam.org/ImaKaeru"
#define SHORTEN_APP_URL @"http://bit.ly/imkaeru"

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
    
    mState = StIdle;

    //UIImage *whiteButton = [[UIImage imageNamed:@"whiteButton"] stretchableImageWithLeftCapWidth:16 topCapHeight:16];
    //[mSendButton1 setBackgroundImage:whiteButton forState:UIControlStateNormal];
    //[mSendButton2 setBackgroundImage:whiteButton forState:UIControlStateNormal];
    //[mSendButton3 setBackgroundImage:whiteButton forState:UIControlStateNormal];
    //[mConfigButton setBackgroundImage:whiteButton forState:UIControlStateNormal];
    
    // iAd を画面外に移動
    CGRect frame;
    frame.size = mAdBannerView.frame.size;
    frame.origin = CGPointMake(0.0f, CGRectGetMaxY(self.view.bounds));
    mAdBannerView.frame = frame;

    mLocation = [[Location alloc] init];
    mLocation.delegate = self;
}

- (void)viewDidUnload
{
    mLocation.delegate = nil;
    mLocation = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateButtonStates];

    if (mConfig.isSendLocation) {
        [mLocation startUpdating];
    } else {
        [mLocation stopUpdating];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI Handlers

- (State)state
{
    return mState;
}

// 状態変更
- (void)setState:(State)newState
{
    mState = newState;
    [self updateButtonStates];
}

// ボタン状態を更新する
- (void)updateButtonStates
{
    mConfig = [Config instance];
    
    [mSendButton1 setTitle:mConfig.message1 forState:UIControlStateNormal];
    [mSendButton2 setTitle:mConfig.message2 forState:UIControlStateNormal];
    [mSendButton3 setTitle:mConfig.message3 forState:UIControlStateNormal];
    
    //[mConfigButton setTitle:_L(@"config") forState:UIControlStateNormal];
    
    BOOL sendEnabled = YES;
    if (self.state != StIdle || (!mConfig.isUseEmail && !mConfig.isUseTwitter)) {
        sendEnabled = NO;
    }
    mSendButton1.enabled = sendEnabled;
    mSendButton2.enabled = sendEnabled;
    mSendButton3.enabled = sendEnabled;
    
    mEmailButton.enabled = (self.state == StIdle);
    mTwitterButton.enabled = (self.state == StIdle);
    
    mEmailButton.selected = mConfig.isUseEmail;
    mTwitterButton.selected = mConfig.isUseTwitter;    
}

// メッセージ送信
- (IBAction)onPushSendMessage:(id)sender
{
    if (self.state != StIdle) return;

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
 
    // 位置情報取得 / 送信開始
    if (mConfig.isSendLocation && ![mLocation hasLocation]) {
        // wait for location update...
        self.state = StGetLocation;
        [mLocation startUpdating];
    } else {
        [self startSend];
    }
}

// 送信開始
- (void)startSend
{
    if (self.state == StSending) {
        return;
    }
    self.state = StSending;

    // 送信する
    // Twitter とメール同時送信の場合は、Twitter送信が完了してからメール送信する
    if (mConfig.isUseTwitter) {
        if (![self sendTwitter]) {
            self.state = StIdle; // error...
        }
    }
    else if (mConfig.isUseEmail) {
        if (![self sendEmail]) {
            self.state = StIdle; // error...
        }
    }
    else {
        self.state = StIdle;
    }
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

#pragma mark - LocationDelegate

- (void)location:(Location *)loc didUpdate:(CLLocation *)location
{
    if (self.state == StGetLocation) {
        [self startSend];
    }
}

- (void)location:(Location *)loc didFail:(NSError *)error
{
    if (self.state == StGetLocation) {
        [self startSend];
    }
}

#pragma mark - Email

// メール送信
- (BOOL)sendEmail
{
    if (![MFMailComposeViewController canSendMail]) {
        // TBD
        return NO;
    }
    
    MFMailComposeViewController *vc = [MFMailComposeViewController new];
    vc.mailComposeDelegate = self;
    
    [vc setToRecipients:[NSArray arrayWithObject:mConfig.emailAddress]];
    [vc setSubject:mMessageToSend]; // TBD
    
    // メール本文作詞絵
    NSMutableString *body = [NSMutableString stringWithString:mMessageToSend];

    NSString *locUrl = [mLocation getLocationUrl];
    if (locUrl != nil) {
        [body appendString:@"\nat "];
        [body appendString:locUrl];
    }

    [body appendString:@"\n\n"];
    [body appendFormat:@"Sent from %@\n%@", _L(@"app_name"), APP_URL];
    [vc setMessageBody:body isHTML:NO];
    
    [self presentModalViewController:vc animated:YES];

    return YES;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
    self.state = StIdle;
}

#pragma mark - Twitter

// Twitter 送信
- (BOOL)sendTwitter
{
    if (mConfig.twitterAddress == nil || [mConfig.twitterAddress length] == 0) {
        // TODO: 宛先なし
        return NO;
    }

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *apiUrl;

    NSMutableString *msg;
    if (mConfig.isUseDirectMessage) {
        // DirectMessage
        apiUrl = @"http://api.twitter.com/1/direct_messages/new.json";

        msg = [NSMutableString stringWithString:mMessageToSend];
        if ([mLocation hasLocation]) {
            [msg appendFormat:@" %@", [mLocation getLocationUrl]];
        }
        
        // direct message では hash tag, app url ともにつけない
        //[msg appendFormat:@" %@", _L(@"hash_tag")];
        //[msg appendFOrmat:@" %@", SHORTEN_APP_URL];
        
        [params setObject:msg forKey:@"text"];
        [params setObject:mConfig.twitterAddress forKey:@"screen_name"];
    } else {
        // mention
        apiUrl = @"http://api.twitter.com/1/statuses/update.json";

        msg = [NSMutableString stringWithFormat:@"@%@", mConfig.twitterAddress];
        [msg appendFormat:@" %@", mMessageToSend];
        [msg appendFormat:@" %@", _L(@"hash_tag")];
        [msg appendString:@" " SHORTEN_APP_URL];
        [params setObject:msg forKey:@"status"];

        if ([mLocation hasLocation]) {
            CLLocation *loc = mLocation.location;
            [params setObject:[NSString stringWithFormat:@"%f", loc.coordinate.latitude] forKey:@"lat"];
            [params setObject:[NSString stringWithFormat:@"%f", loc.coordinate.longitude] forKey:@"long"];
            [params setObject:@"true" forKey:@"display_coordinates"];
        }
    }

    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [store requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if (!granted) {
            // エラー: Twitter アカウント拒否
            [self performSelectorOnMainThread:@selector(tweetFailed:) withObject:_L(@"error_twitter_denied") waitUntilDone:NO];
            return;
        }
        NSArray *accounts = [store accountsWithAccountType:accountType];
        if ([accounts count] <= 0) {
            // エラー、アカウントなし
            [self performSelectorOnMainThread:@selector(tweetFailed:) withObject:_L(@"error_setup_twitter_account") waitUntilDone:NO];
            return;
        }

        ACAccount *account = [accounts objectAtIndex:0];

        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        // request 作成
        TWRequest *req = [[TWRequest alloc] initWithURL:[NSURL URLWithString:apiUrl]
                                             parameters:params
                                          requestMethod:TWRequestMethodPOST];
        [req setAccount:account];
        [req performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            int statusCode = [urlResponse statusCode];
            if (statusCode == 200) {
                [self performSelectorOnMainThread:@selector(tweetDone) withObject:nil waitUntilDone:NO];
            } else {
                NSDictionary *headers = [urlResponse allHeaderFields];
                for (NSString *key in headers) {
                    NSLog(@"%@ = %@", key, [headers objectForKey:key]);
                }
                
                NSString *statusMessage = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
                [self performSelectorOnMainThread:@selector(tweetFailed:) withObject:statusMessage waitUntilDone:NO];
            }
        }];
    }];

    return YES;
}

- (void)tweetDone
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if (mConfig.isUseEmail) {
        if (![self sendEmail]) {
            self.state = StIdle;
        }
    } else {
        [self showMessage:_L(@"tweet_completed") title:@"Twitter"];
        self.state = StIdle;
    }
}

- (void)tweetFailed:(NSString *)statusMessage
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *msg = [NSString stringWithFormat:@"%@ (%@)", _L(@"tweet_failed"), statusMessage];
    [self showError:msg];

    self.state = StIdle;
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
