//
//  Twitter.h
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthCore.h"
#import "OAuth+Additions.h"

@interface Twitter : NSObject

+ (BOOL)authenticate:(NSString *)username password:(NSString *)password;
+ (BOOL)tweet:(NSString *)status;

@end
