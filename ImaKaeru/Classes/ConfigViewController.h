// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import <UIKit/UIKit.h>
#import "Config.h"

@interface ConfigViewController : UITableViewController
{
    Config *mConfig;
    
    __weak IBOutlet UITextField *mTextMessage1;
    __weak IBOutlet UITextField *mTextMessage2;
    __weak IBOutlet UITextField *mTextMessage3;
    __weak IBOutlet UISwitch *mSwitchLocation;
    __weak IBOutlet UISwitch *mSwitchDirectMessage;
    __weak IBOutlet UITextField *mTextEmail;
    __weak IBOutlet UITextField *mTextTwitterName;
    
    __weak IBOutlet UILabel *mLabelMessage1;
    __weak IBOutlet UILabel *mLabelMessage2;
    __weak IBOutlet UILabel *mLabelMessage3;
    __weak IBOutlet UILabel *mLabelLocation;
    __weak IBOutlet UILabel *mLabelDirectMessage;
    __weak IBOutlet UILabel *mLabelTwitterDestination;
}

- (IBAction)doneAction:(id)sender;

@end
