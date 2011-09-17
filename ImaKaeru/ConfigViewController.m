//
//  ConfigViewController.m
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ConfigViewController.h"
//#import "TwitterConfigViewController.h"

#import "TwitterSecret.h"

#define K_MSG1 0
#define K_MSG2 1
#define K_MSG3 2

#define K_IS_USE_EMAIL  3
#define K_EMAIL_ADDRESS 4

#define K_IS_USE_TWITTER 5
#define K_IS_USE_DIRECT_MESSAGE 6
#define K_TWITTER_ADDRESS 7


@interface ConfigViewController ()
- (void)doneAction:(id)sender;
- (UITableViewCell *)getPlainCell:(NSString *)label;
- (CellWithSwitch *)getCellWithSwitch:(int)identifier label:(NSString *)label on:(BOOL)on;
- (CellWithSwitch *)getCellWithText:(int)identifier label:(NSString *)label placeholder:(NSString *)placeholder text:(NSString *)text;
- (void)authTwitter;
@end

@implementation ConfigViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        mConfig = [Config instance];
    }
    return self;
}

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

    self.title = @"設定";
    
    self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
}

- (void)doneAction:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"メッセージ設定";
        case 1:
            return @"Eメール設定";
        case 2:
            return @"Twitter設定";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 2;
        case 2:
            return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    switch (indexPath.section) {
        case 0:
            // Message settings
            switch (indexPath.row) {
                case 0:
                    cell = [self getCellWithText:K_MSG1 label:@"メッセージ1" placeholder:@"Message" text:mConfig.message1];
                    break;
                case 1:
                    cell = [self getCellWithText:K_MSG2 label:@"メッセージ2" placeholder:@"Message" text:mConfig.message2];
                    break;
                case 2:
                    cell = [self getCellWithText:K_MSG3 label:@"メッセージ3" placeholder:@"Message" text:mConfig.message3];
                    break;
            }
            break;
            
        case 1:
            // Email settings
            switch (indexPath.row) {
                case 0:
                    // Email on/off
                    cell = [self getCellWithSwitch:K_IS_USE_EMAIL label:@"Eメール送信" on:mConfig.isUseEmail];
                    break;
                    
                case 1:
                    cell = [self getCellWithText:K_EMAIL_ADDRESS label:@"送信先" placeholder:@"example.gmail.com" text:mConfig.emailAddress];
                    break;
            }
            break;
            
        case 2:
            // Twitter settings
            switch (indexPath.row) {
                case 0:
                    // Twitter on/off
                    cell = [self getCellWithSwitch:K_IS_USE_TWITTER label:@"Twitter送信" on:mConfig.isUseTwitter];
                    break;

                case 1:
                    // direct message
                    cell = [self getCellWithSwitch:K_IS_USE_DIRECT_MESSAGE label:@"ダイレクトメッセージ" on:mConfig.isUseDirectMessage];
                    break;
                    
                case 2:
                    // address
                    cell = [self getCellWithText:K_TWITTER_ADDRESS label:@"送信先" placeholder:@"twitter account" text:mConfig.twitterAddress];
                    break;
                case 3:
                    // twitter account
                    cell = [self getPlainCell:@"アカウント設定"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
            }
            break;
    }
    
    /*
    
    return cell;
     */
    
    return cell;
}

- (UITableViewCell *)getPlainCell:(NSString *)text
{
    static NSString *CellIdentifier = @"PlainCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.text = text;
    return cell;
}

- (CellWithSwitch *)getCellWithSwitch:(int)identifier label:(NSString *)label on:(BOOL)on
{
    CellWithSwitch *cell;
    
    cell = [CellWithSwitch getCell:self.tableView];
    [cell setLabel:label];
    cell.identifier = identifier;
    cell.on = on;
    cell.delegate = self;
    return cell;
}

- (CellWithText *)getCellWithText:(int)identifier label:(NSString *)label placeholder:(NSString *)placeholder text:(NSString *)text
{
    CellWithText *cell;
    
    cell = [CellWithText getCell:self.tableView];
    [cell setLabel:label];
    cell.identifier = identifier;
    cell.placeholder = placeholder;
    cell.text = text;
    cell.delegate = self;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && indexPath.row == 3) {
        // setup twitter account
        [self authTwitter];
    }
}

#pragma mark - Data changed
- (void)cellWithSwitchChanged:(CellWithSwitch *)cell
{
    switch (cell.identifier) {
        case K_IS_USE_EMAIL:
            mConfig.isUseEmail = cell.on;
            break;
            
        case K_IS_USE_TWITTER:
            mConfig.isUseTwitter = cell.on;
            break;
            
        case K_IS_USE_DIRECT_MESSAGE:
            mConfig.isUseDirectMessage = cell.on;
            break;
    }
    [mConfig save];
}

- (void)cellWithTextChanged:(CellWithText *)cell
{
    switch (cell.identifier) {
        case K_MSG1:
            mConfig.message1 = cell.text;
            break;

        case K_MSG2:
            mConfig.message2 = cell.text;
            break;
            
        case K_MSG3:
            mConfig.message3 = cell.text;
            break;
            
        case K_EMAIL_ADDRESS:
            mConfig.emailAddress = cell.text;
            break;
            
        case K_TWITTER_ADDRESS:
            mConfig.twitterAddress = cell.text;
            break;
    }
    [mConfig save];
}


//=============================================================================================================================
#pragma mark - Twitter
- (void)authTwitter
{
    SA_OAuthTwitterEngine *engine = [[SA_OAuthTwitterEngine alloc] initWithDelegate:self];
    engine.consumerKey = CONSUMER_KEY;
    engine.consumerSecret = CONSUMER_SECRET;
    
    UIViewController *vc = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:engine delegate:self];
    if (vc) {
        [self.navigationController presentModalViewController:vc animated:YES];
    } else {
        // TODO:
    }
}

#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
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

@end
