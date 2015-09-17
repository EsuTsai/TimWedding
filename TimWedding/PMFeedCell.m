//
//  PMFeedCell.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/13.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "PMFeedCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PMFeedCell

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
    
    NSLog(@"%@",[data objectForKey:@"username"]);
    
    
    UILabel *nickName  = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_BOUNDS.size.width-20, 40)];
    nickName.text      = [data objectForKey:@"username"];
    nickName.textColor = [UIColor darkGrayColor];
    nickName.font      = [UIFont fontWithName:defaultFont size:18];
    [self.contentView addSubview:nickName];
    
    UIImageView *feedImage           = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.width-40-30-40-4-1)];
    feedImage.contentMode            = UIViewContentModeScaleAspectFit;
    feedImage.clipsToBounds          = YES;
    feedImage.userInteractionEnabled = YES;
    
    NSString *picUrlString = [NSString stringWithFormat:@"%@",[data objectForKey:@"uuid"]];
    
    [feedImage sd_setImageWithURL:[NSURL URLWithString:picUrlString] placeholderImage:[UIImage imageNamed:@"pic-loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

    [self.contentView addSubview:feedImage];
    
    UILabel *infoLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10, feedImage.frame.origin.y + feedImage.frame.size.height, SCREEN_BOUNDS.size.width-20, 30)];
    infoLabel.text      = [NSString stringWithFormat:@"0個讚 %@個留言",[data objectForKey:@"messagecount"]];
    infoLabel.textColor = [UIColor darkGrayColor];
    infoLabel.font      = [UIFont fontWithName:defaultFont size:13];
    [self.contentView addSubview:infoLabel];
    
    UILabel *line        = [[UILabel alloc] initWithFrame:CGRectMake(10, infoLabel.frame.origin.y +infoLabel.frame.size.height, SCREEN_BOUNDS.size.width-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, line.frame.origin.y + line.frame.size.height, SCREEN_BOUNDS.size.width, 40)];
    [self.contentView addSubview:buttonLabel];
    
    UILabel *line2        = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonLabel.frame.origin.y +buttonLabel.frame.size.height, SCREEN_BOUNDS.size.width, 4)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line2];

    
}

@end
