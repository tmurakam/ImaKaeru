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

    mConfig = [Config instance];

    [mSendButton1 setTitle:mConfig.message1 forState:UIControlStateNormal];
    [mSendButton2 setTitle:mConfig.message2 forState:UIControlStateNormal];
    [mSendButton3 setTitle:mConfig.message3 forState:UIControlStateNormal];
    
    [mConfigButton setTitle:_L(@"config") forState:UIControlStateNormal];
    
    // iAd を画面外に移動
    CGRect frame;
    frame.size = mAdBannerView.frame.size;
    frame.origin = CGPointMake(0.0f, CGRectGetMaxY(self.view.bounds));
    mAdBannerView.frame = frame;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UI Handlers

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
    
    SA_OAuthTwitterEngine *engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
    engine.consumerKey = CONSUMER_KEY;
    engine.consumerSecret = CONSUMER_SECRET;
    
    UIViewController *vc = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:engine delegate:self];
    if (vc) {
        // TODO: 認証されていない
        [self showError:_L(@"error_setup_twitter_account")];
    } else {
        NSString *msg;
        if (mConfig.isUseDirectMessage) {
            msg = [NSString stringWithFormat:@"%@ %@ http://iphone.tmurakam.org/ImaKaeru", mMessageToSend, _L(@"hash_tag")];
            [engine sendDirectMessage:msg to:mConfig.twitterAddress];
        } else {
            // mention
            msg = [NSString stringWithFormat:@"@%@ %@ %@ http://iphone.tmurakam.org/ImaKaeru", mConfig.twitterAddress, mMessageToSend, _L(@"hash_tag")];
           [engine sendUpdate:msg];
        }
    }
}

#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *)data forUsername: (NSString *)username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject:data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *)cachedTwitterOAuthDataForUsername:(NSString *)username
{
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");
}

#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);

    if (mConfig.isUseEmail) {
        [self sendEmail];
    } else {
        [self showMessage:_L(@"tweet_completed") title:@"Twitter"];
    }
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
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
