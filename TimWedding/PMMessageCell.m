//
//  PMMessageCell.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/17.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "PMMessageCell.h"
#import "NSString+Height.h"
#import <NSDate+TimeAgo.h>
#import "PMLabelCopy.h"

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
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_BOUNDS.size.width-20, 15)];
    userName.text = [data objectForKey:@"username"];
    userName.textColor = [UIColor colorWithRed:78.0/255.0 green:139.0/255.0 blue:115.0/255.0 alpha:1.000];
    userName.font = [UIFont fontWithName:defaultFontMedium size:13.0];
    
    [self.contentView addSubview:userName];
    
    
    UILabel *timeLabel      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_BOUNDS.size.width/2, 5, (SCREEN_BOUNDS.size.width/2)-10, 15)];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor     = [UIColor lightGrayColor];
    timeLabel.font          = [UIFont fontWithName:defaultFont size:13];
    [self.contentView addSubview:timeLabel];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSString *timeStr = [[NSString stringWithFormat:@"%@", [data objectForKey:@"createdat"]] substringToIndex:19];
    
//    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    NSDate *date = [df dateFromString:timeStr];
    NSString *localDateString = [date timeAgo];
    timeLabel.text          = localDateString;
    
    PMLabelCopy *description = [[PMLabelCopy alloc] initWithFrame:CGRectMake(10, userName.frame.origin.y+userName.frame.size.height+5, SCREEN_BOUNDS.size.width-20, 0)];
    description.numberOfLines = 0;
    description.text = [data objectForKey:@"description"];
    description.font = [UIFont fontWithName:defaultFont size:15];
    CGFloat cellHeight = [[NSString circulateLabelHeight:[data objectForKey:@"description"] labelWidth:SCREEN_BOUNDS.size.width-20 labelFont:[UIFont fontWithName:defaultFont size:16]] floatValue];
    if(cellHeight > 0){
        description.frame = CGRectMake(description.frame.origin.x, description.frame.origin.y, description.frame.size.width, cellHeight);
    }
    
    [self.contentView addSubview:description];
    
    UILabel *line        = [[UILabel alloc] initWithFrame:CGRectMake(10, description.frame.origin.y+cellHeight + 5, SCREEN_BOUNDS.size.width-20, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.849 alpha:1.000];
//    if(cellHeight > 20){
//        line.frame = CGRectMake(line.frame.origin.x, description.frame.origin.y + description.frame.size.height + 5, line.frame.size.width, 1);
//    }
    [self.contentView addSubview:line];
}

@end
