//
//  PMMessageCell.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/17.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "PMMessageCell.h"

@implementation PMMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(id)data
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 80)];
    userName.text = [data objectForKey:@"username"];
    [self.contentView addSubview:userName];
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN_BOUNDS.size.width-50, 80)];
    description.text = [data objectForKey:@"description"];
    [self.contentView addSubview:description];
}

@end
