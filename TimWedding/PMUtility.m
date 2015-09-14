//
//  PMUtility.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/15.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "PMUtility.h"

@implementation PMUtility

+ (instancetype)sharedInstance
{
    static PMUtility *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[PMUtility alloc] init];
    });
    return shareInstance;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        // initialize stuff here
    }
    
    return self;
}

- (NSString *)userToken
{
    NSString *token = @"";
    NSUserDefaults *userDefaults = USER_DEFAULTS;
    if ([userDefaults valueForKey:kUserToken]){
        token = [userDefaults valueForKey:kUserToken];
    }
    return token;
}

@end
