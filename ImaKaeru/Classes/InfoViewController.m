// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import "InfoViewController.h"
#import "Common.h"

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
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)showHelp:(id)sender {
	[self showUrl:@"http://iphone.tmurakam.org/ImaKaeru"];
}

- (IBAction)showWebsite:(id)sender {
	[self showUrl:@"http://iphone.tmurakam.org/ImaKaeru"];
}

- (IBAction)showFacebook:(id)sender {
	[self showUrl:@"http://m.facebook.com/pages/ImaKaeru/208663542534847"];    
}

- (void)showUrl:(NSString *)url
{
    NSURL *u = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:u];
}
@end
