// -*-  Mode:ObjC; c-basic-offset:4; tab-width:8; indent-tabs-mode:nil -*-
/*
 * ImaKaeru
 * Copyright (C) 2011, Takuya & Yasuko Murakami, All rights reserved.
 * For conditions of distribution and use, see LICENSE file.
 */

#import <UIKit/UIKit.h>

@class CellWithText;

@protocol CellWithTextDelegate
- (void)cellWithTextChanged:(CellWithText *)cell;
@end

@interface CellWithText : UITableViewCell <UITextFieldDelegate>
{
    IBOutlet UILabel *mLabel;
    IBOutlet UITextField *mTextField;
    
    int mIdentifier;
    
    __unsafe_unretained id<CellWithTextDelegate> mDelegate;
}

@property int identifier;

@property(unsafe_unretained) id<CellWithTextDelegate> delegate;
@property(strong) NSString *placeholder;
@property(strong) NSString *text;

+ (CellWithText *)getCell:(UITableView *)tableView;
- (void)setLabel:(NSString *)label;

@end
