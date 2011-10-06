// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import <UIKit/UIKit.h>

@class CellWithSwitch;

@protocol CellWithSwitchDelegate
- (void)cellWithSwitchChanged:(CellWithSwitch *)cell;
@end

@interface CellWithSwitch : UITableViewCell
{
    IBOutlet UILabel *mLabel;
    IBOutlet UISwitch *mSwitch;
    
    int mIdentifier;
    
    __unsafe_unretained id<CellWithSwitchDelegate> mDelegate;
}

@property int identifier;

@property(unsafe_unretained) id<CellWithSwitchDelegate> delegate;
@property BOOL on;

+ (CellWithSwitch *)getCell:(UITableView *)tableView;
- (void)setLabel:(NSString *)label;

@end
