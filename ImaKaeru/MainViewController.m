//
//  ViewController.m
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

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
}

- (IBAction)showConfigViewController:(id)sender
{
    // TBD
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


@end
