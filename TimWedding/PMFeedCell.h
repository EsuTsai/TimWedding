//
//  PMFeedCell.h
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/13.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol messageBtnDelegate <NSObject>

- (void)openMessagePage:(NSInteger)index;

@end

@interface PMFeedCell : UITableViewCell

- (void)setContent:(id)data index:(NSInteger)index;
@property (nonatomic, assign) id<messageBtnDelegate> cellDelegate;
@end
