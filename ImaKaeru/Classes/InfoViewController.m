// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import "InfoViewController.h"
#import "Common.h"
#import "WebViewController.h"

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.title = _L(@"info");

    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    
    [mAppNameLabel setText:_L(@"app_name")];
     
    NSString *version = [info valueForKey:@"CFBundleShortVersionString"];
    [mVersionLabel setText:[NSString stringWithFormat:@"Version %@", version]];
}

- (void)viewDidUnload
{
    mAppNameLabel = nil;
    mVersionLabel = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// WebView からだと facebook にログインしていない状態なので、
// Safari で開く
- (IBAction)showFacebook:(id)sender {
    NSURL *url = [NSURL URLWithString:_L(@"facebook_url")];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *sid = [segue identifier];
    WebViewController *vc = [segue destinationViewController];
    
    if ([sid isEqualToString:@"showHelp"]) {
        vc.urlString = _L(@"help_url");
    }
    else if ([sid isEqualToString:@"showWebsite"]) {
        vc.urlString = _L(@"website_url");
    }
    //else if ([sid isEqualToString:@"showFacebook"]) {
    //    vc.urlString = _L(@"facebook_url");
    //}
}

@end
