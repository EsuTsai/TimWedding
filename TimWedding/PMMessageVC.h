//
//  PMMessageVC.h
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/16.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

@protocol EMMessageDelegate <NSObject>

@optional
- (void)refreshMessageCount:(NSInteger)count;
@end


#import "PMViewController.h"

@interface PMMessageVC : PMViewController

- (id)initWithFeed:(NSString *)objectId;
@property ( nonatomic, assign ) id<EMMessageDelegate> messageDelegate;

@end
