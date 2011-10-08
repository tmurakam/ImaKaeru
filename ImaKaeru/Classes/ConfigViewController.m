// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import "ConfigViewController.h"
#import "InfoViewController.h"

#import "Common.h"

#define K_MSG1 0
#define K_MSG2 1
#define K_MSG3 2

#define K_IS_SEND_LOCATION 3

#define K_EMAIL_ADDRESS 4

#define K_IS_USE_DIRECT_MESSAGE 6
#define K_TWITTER_ADDRESS 7

@interface ConfigViewController ()
- (void)loadConfig;
- (void)saveConfig;
@end

@implementation ConfigViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _L(@"config");
    
    self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];

    mConfig = [Config instance];
    
    // localization
    mLabelMessage1.text = [NSString stringWithFormat:@"%@1", _L(@"message")];
    mLabelMessage2.text = [NSString stringWithFormat:@"%@2", _L(@"message")];
    mLabelMessage3.text = [NSString stringWithFormat:@"%@3", _L(@"message")];
    mLabelLocation.text = _L(@"send_location");
    mLabelDirectMessage.text = _L(@"direct_message");
    mLabelTwitterDestination.text = _L(@"destination");
    
    [self loadConfig];
}   

- (void)viewDidUnload
{
    mTextMessage1 = nil;
    mTextMessage2 = nil;
    mTextMessage3 = nil;
    mSwitchLocation = nil;
    mSwitchDirectMessage = nil;
    mTextEmail = nil;
    mTextTwitterName = nil;
    mLabelMessage1 = nil;
    mLabelMessage2 = nil;
    mLabelMessage3 = nil;
    mLabelLocation = nil;
    mLabelDirectMessage = nil;
    mLabelTwitterDestination = nil;
    mConfig = nil;

    [super viewDidUnload];
}

- (void)loadConfig
{
    mTextMessage1.text = mConfig.message1;
    mTextMessage2.text = mConfig.message2;
    mTextMessage3.text = mConfig.message3;
    mSwitchLocation.on = mConfig.isSendLocation;
    
    mTextEmail.text = mConfig.emailAddress;
    
    mSwitchDirectMessage.on = mConfig.isUseDirectMessage;
    mTextTwitterName.text = mConfig.twitterAddress;
}

- (void)saveConfig
{
    mConfig.message1 = mTextMessage1.text;
    mConfig.message2 = mTextMessage2.text;
    mConfig.message3 = mTextMessage3.text;
    mConfig.isSendLocation =  mSwitchLocation.on;
    
    mConfig.emailAddress = mTextEmail.text;
    
    mConfig.isUseDirectMessage = mSwitchDirectMessage.on;
    mConfig.twitterAddress = mTextTwitterName.text;

    [mConfig save];
}

- (IBAction)doneAction:(id)sender
{
    [self saveConfig];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _L(@"messages_config");
        case 1:
            return _L(@"email_config");
        case 2:
            return _L(@"twitter_config");
    }
    return nil;
}

@end
