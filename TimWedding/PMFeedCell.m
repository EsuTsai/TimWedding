//
//  PMFeedCell.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/13.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "PMFeedCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <FontAwesomeKit/FontAwesomeKit.h>
#import <Parse/Parse.h>
#import "PMUtility.h"
#import <NSDate+TimeAgo.h>
#import "NSString+Height.h"

@interface PMFeedCell ()
{
    NSDictionary *dataDic;
    UIButton *likeBtn;
    NSInteger cellIndex;
    UIButton *infoLabel;
}

@end
@implementation PMFeedCell
@synthesize cellDelegate = _cellDelegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(id)data index:(NSInteger)index
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    dataDic = data;
    cellIndex = index;
    
    UILabel *nickName  = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_BOUNDS.size.width-20, 35)];
    nickName.text      = [data objectForKey:@"username"];
    nickName.textColor = [UIColor darkGrayColor];
    nickName.font      = [UIFont fontWithName:defaultFontMedium size:18];
    [self.contentView addSubview:nickName];
    
    UILabel *timeLabel      = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_BOUNDS.size.width/2, 5, (SCREEN_BOUNDS.size.width/2)-10, 35)];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor     = [UIColor lightGrayColor];
    timeLabel.font          = [UIFont fontWithName:defaultFont size:13];
    [self.contentView addSubview:timeLabel];
    NSDateFormatter *df       = [NSDateFormatter new];
    [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    df.timeZone               = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSString *timeStr         = [[NSString stringWithFormat:@"%@", [data objectForKey:@"createdat"]] substringToIndex:19];

//    df.timeZone               = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    NSDate *date              = [df dateFromString:timeStr];
    NSString *localDateString = [date timeAgo];
    timeLabel.text            = localDateString;
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(10, nickName.frame.origin.y + nickName.frame.size.height, SCREEN_BOUNDS.size.width-20, 0)];
    description.text = [data objectForKey:@"description"];
    description.numberOfLines = 0;
    description.font = [UIFont fontWithName:defaultFont size:14.];
    CGFloat cellHeight = [[NSString circulateLabelHeight:[data objectForKey:@"description"] labelWidth:SCREEN_BOUNDS.size.width-20 labelFont:[UIFont fontWithName:defaultFont size:14]] floatValue];
    if(cellHeight > 0){
        description.frame = CGRectMake(description.frame.origin.x+5, description.frame.origin.y, description.frame.size.width, cellHeight);
    }
    [self.contentView addSubview:description];
    
    NSString *picUrlString = [NSString stringWithFormat:@"%@",[data objectForKey:@"uuid"]];
    
    UIImageView *feedImage           = [[UIImageView alloc] initWithFrame:CGRectMake(0, description.frame.origin.y+description.frame.size.height+5, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.width)];
    feedImage.contentMode            = UIViewContentModeScaleAspectFill;
    feedImage.clipsToBounds          = YES;
    feedImage.userInteractionEnabled = YES;
    feedImage.tag                    = index;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage:)];
    [feedImage addGestureRecognizer:tapGesture];    
    [feedImage sd_setImageWithURL:[NSURL URLWithString:picUrlString] placeholderImage:[UIImage imageNamed:@"pic-loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];

//    feedImage.layer.shadowColor = [UIColor colorWithWhite:0.544 alpha:1.000].CGColor;
//    feedImage.layer.shadowOffset = CGSizeMake(3.0, 3.0);
//    feedImage.layer.shadowRadius = 3.0;
//    feedImage.layer.shadowOpacity = 1.0;
    [self.contentView addSubview:feedImage];
    
    infoLabel  = [[UIButton alloc] initWithFrame:CGRectMake(10, feedImage.frame.origin.y + feedImage.frame.size.height+5, SCREEN_BOUNDS.size.width-20, 30)];
    infoLabel.tag = index;
    [infoLabel setTitle:[NSString stringWithFormat:@"%@個讚 %@個留言",[data objectForKey:@"likecount"],[data objectForKey:@"messagecount"]] forState:UIControlStateNormal];
    [infoLabel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    infoLabel.titleLabel.font      = [UIFont fontWithName:defaultFont size:13];
    infoLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [infoLabel addTarget:self action:@selector(messagePress:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:infoLabel];
    
    UILabel *line        = [[UILabel alloc] initWithFrame:CGRectMake(10, infoLabel.frame.origin.y +infoLabel.frame.size.height+5, SCREEN_BOUNDS.size.width-20, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.849 alpha:1.000];
    [self.contentView addSubview:line];
    
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, line.frame.origin.y + line.frame.size.height+5, SCREEN_BOUNDS.size.width, 40)];
    buttonLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:buttonLabel];
    
    likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonLabel.frame.size.width/2, buttonLabel.frame.size.height)];
    [likeBtn addTarget:self action:@selector(likePress:) forControlEvents:UIControlEventTouchUpInside];
    likeBtn.tag = 0;
    likeBtn.userInteractionEnabled = YES;
    for (id obj in [data objectForKey:@"likeList"])
    {
        if([obj isEqualToString:[[PMUtility sharedInstance] userToken]]){
            likeBtn.tag = 1;
            likeBtn.userInteractionEnabled = NO;
            break;
        }
    }
    FAKIonIcons *likeIcon = [FAKIonIcons ios7HeartOutlineIconWithSize:30];
    [likeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:78.0/255.0 green:139.0/255.0 blue:115.0/255.0 alpha:1.000]];
    if(likeBtn.tag == 1){
        likeIcon = [FAKIonIcons ios7HeartIconWithSize:30];
        [likeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1.000]];
    }

    UIImage *likeImage    = [likeIcon imageWithSize:CGSizeMake(30, 30)];
    [likeBtn setImage:likeImage forState:UIControlStateNormal];
    [buttonLabel addSubview:likeBtn];
    
    UIButton *messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonLabel.frame.size.width/2, 0, buttonLabel.frame.size.width/2, buttonLabel.frame.size.height)];
    messageBtn.tag = index;
    [messageBtn addTarget:self action:@selector(messagePress:) forControlEvents:UIControlEventTouchUpInside];
    FAKIonIcons *messageIcon = [FAKIonIcons ios7ChatbubbleOutlineIconWithSize:30];
    [messageIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:78.0/255.0 green:139.0/255.0 blue:115.0/255.0 alpha:1.000]];
    UIImage *messageImage    = [messageIcon imageWithSize:CGSizeMake(30, 30)];
    [messageBtn setImage:messageImage forState:UIControlStateNormal];
    [buttonLabel addSubview:messageBtn];
    
    UILabel *line2        = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonLabel.frame.origin.y +buttonLabel.frame.size.height+5, SCREEN_BOUNDS.size.width, 4)];
    line2.backgroundColor = [UIColor colorWithWhite:0.849 alpha:1.000];
    [self.contentView addSubview:line2];
    
}

- (void)likePress:(UIButton *)sender
{
    FAKIonIcons *likeIcon = [FAKIonIcons ios7HeartIconWithSize:30];
    [likeIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1.000]];
    UIImage *likeImage    = [likeIcon imageWithSize:CGSizeMake(30, 30)];
    [likeBtn setImage:likeImage forState:UIControlStateNormal];
    likeBtn.userInteractionEnabled = NO;
    
    NSString *newLike = [NSString stringWithFormat:@"%ld",[[dataDic objectForKey:@"likecount"] integerValue]+1];
    [infoLabel setTitle:[NSString stringWithFormat:@"%@個讚 %@個留言",newLike,[dataDic objectForKey:@"messagecount"]] forState:UIControlStateNormal];
    
    __block NSMutableArray *likeList = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
    [query getObjectInBackgroundWithId:[dataDic objectForKey:@"id"]
                                 block:^(PFObject *postObject, NSError *error) {
                                     if(!error){
                                         if(sender.tag == 1){
                                             [postObject incrementKey:@"likecount" byAmount:@-1];
                                         }else{
                                             [postObject incrementKey:@"likecount"];
                                         }
                                         likeList = [postObject[@"likeList"] mutableCopy];
                                         if(sender.tag == 1){
                                             [likeList removeObject:[[PMUtility sharedInstance] userToken]];
                                         }else{
                                             [likeList addObject:[[PMUtility sharedInstance] userToken]];
                                         }
                                         postObject[@"likeList"] = likeList;
                                         [postObject saveInBackground];
                                         [self likeBtnPress:likeList index:cellIndex status:sender.tag];
                                     }
                                     
                                 }];
}

- (void)likeBtnPress:(NSMutableArray *)likeList index:(NSInteger)index status:(NSInteger)status
{
    if(_cellDelegate && [_cellDelegate respondsToSelector:@selector(updateLikeData:index:status:)]){
        [_cellDelegate updateLikeData:likeList index:index status:status];
    }
}

- (void)messagePress:(UIButton *)sender
{
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(openMessagePage:)]){
        
        [_cellDelegate openMessagePage:sender.tag];
        
    }

}

- (void)didTapImage:(UITapGestureRecognizer *)tapGesture

{
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(openImageWithTag:view:)]){
        
        [_cellDelegate openImageWithTag:tapGesture.view.tag view:(UIImageView *)tapGesture.view];
        
    }

}

@end
