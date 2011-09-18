//
//  ViewController.m
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "ConfigViewController.h"

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

    [mSendButton1 setTitle:mConfig.message1 forState:UIControlStateNormal];
    [mSendButton2 setTitle:mConfig.message2 forState:UIControlStateNormal];
    [mSendButton3 setTitle:mConfig.message3 forState:UIControlStateNormal];
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
    NSString *message = nil;
    
    if (sender == mSendButton1) {
        message = mConfig.message1;
    }
    else if (sender == mSendButton2) {
        message = mConfig.message2;
    }
    else if (sender == mSendButton3) {
        message = mConfig.message3;
    }
    
    if (mConfig.isUseEmail) {
        [self sendEmail:message];
    }
    if (mConfig.isUseTwitter) {
        [self sendTwitter:message];
    }
}

- (IBAction)showConfigViewController:(id)sender
{
    ConfigViewController *vc = [[ConfigViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentModalViewController:nv animated:YES];
}

- (IBAction)showInfoViewController:(id)sender
{
    // TBD
}

#pragma mark - Email
- (void)sendEmail:(NSString *)message
{
    if (![MFMailComposeViewController canSendMail]) {
        // TBD
        return;
    }
    
    MFMailComposeViewController *vc = [MFMailComposeViewController new];
    vc.mailComposeDelegate = self;
    
    [vc setToRecipients:[NSArray arrayWithObject:mConfig.emailAddress]];
    [vc setSubject:message]; // TBD
    
    NSMutableString *body = [NSMutableString stringWithString:message];
    [body appendString:@"\n\n"];
    [body appendString:@"Sent from いまカエル\nhttp://iphone.tmurakam.org/ImaKaeru"];
    [vc setMessageBody:body isHTML:NO];
    
    [self presentModalViewController:vc animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - Twitter
- (void)sendTwitter:(NSString *)message
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
        // 認証されていない
        [self presentModalViewController:vc animated:YES];
    } else {
        NSString *msg;
        if (mConfig.isUseDirectMessage) {
            msg = [NSString stringWithFormat:@"%@ #ImaKaeru http://iphone.tmurakam.org/ImaKaeru", message];
            [engine sendDirectMessage:msg to:mConfig.twitterAddress];
        } else {
            // mention
            msg = [NSString stringWithFormat:@"@%@ %@ #ImaKaeru http://iphone.tmurakam.org/ImaKaeru", mConfig.twitterAddress, message];
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
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"iAd loaded");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAd load failed");
}

@end
