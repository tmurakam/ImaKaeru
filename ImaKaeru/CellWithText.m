//
//  CellWithSwitch.m
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CellWithText.h"

@interface CellWithText ()
- (void)setUp;
- (void)textChanged:(id)sender;
@end

@implementation CellWithText

@synthesize identifier = mIdentifier;
@synthesize delegate = mDelegate;

#define CELL_ID @"CellWithText"

+ (CellWithText *)getCell:(UITableView *)tableView
{
    CellWithText *cell = (CellWithText *)[tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"CellWithText" bundle:nil];
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        cell = [array objectAtIndex:0];
        
        [cell setUp];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)setUp
{
    [mTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setLabel:(NSString *)label
{
    [mLabel setText:label];
}

- (void)setText:(NSString *)text
{
    [mTextField setText:text];
}

- (NSString *)text
{
    return [mTextField text];
}

- (void)textChanged:(id)sender {
    [mDelegate cellWithTextChanged:self];
}

#if 0
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#endif

@end
