//
//  PMUtility.h
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/15.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMUtility : NSObject

+ (instancetype)sharedInstance;
- (NSString *)userToken;
- (NSString *)userName;
- (void)updateUserName:(NSString *)userName;

@end
