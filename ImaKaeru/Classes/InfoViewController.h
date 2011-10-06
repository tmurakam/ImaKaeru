// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController
{
    
    __weak IBOutlet UILabel *mAppNameLabel;
    __weak IBOutlet UILabel *mVersionLabel;
}

- (IBAction)doneAction:(id)sender;
- (IBAction)showHelp:(id)sender;
- (IBAction)showWebsite:(id)sender;
- (IBAction)showFacebook:(id)sender;

- (void)showUrl:(NSString *)url;

@end
