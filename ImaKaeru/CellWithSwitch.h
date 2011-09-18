//
//  CellWithSwitch.h
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

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
