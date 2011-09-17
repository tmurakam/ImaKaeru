//
//  CellWithSwitch.h
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellWithText;

@protocol CellWithTextDelegate
- (void)cellWithTextChanged:(CellWithText *)cell;
@end

@interface CellWithText : UITableViewCell
{
    IBOutlet UILabel *mLabel;
    IBOutlet UITextField *mTextField;
    
    int mIdentifier;
    
    id<CellWithTextDelegate> __unsafe_unretained mDelegate;
}

@property(nonatomic) int identifier;

@property(nonatomic,unsafe_unretained) id<CellWithTextDelegate> delegate;
@property(nonatomic,strong) NSString *placeholder;
@property(nonatomic,strong) NSString *text;

+ (CellWithText *)getCell:(UITableView *)tableView;
- (void)setLabel:(NSString *)label;

@end
