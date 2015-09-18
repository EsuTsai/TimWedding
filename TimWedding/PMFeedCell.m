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

@interface PMFeedCell ()
{
    NSDictionary *dataDic;
    UIButton *likeBtn;
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
    
    UIButton *infoLabel  = [[UIButton alloc] initWithFrame:CGRectMake(10, feedImage.frame.origin.y + feedImage.frame.size.height, SCREEN_BOUNDS.size.width-20, 30)];
    infoLabel.tag = index;
    [infoLabel setTitle:[NSString stringWithFormat:@"0個讚 %@個留言",[data objectForKey:@"messagecount"]] forState:UIControlStateNormal];
    [infoLabel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    infoLabel.titleLabel.font      = [UIFont fontWithName:defaultFont size:13];
    infoLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [infoLabel addTarget:self action:@selector(messagePress:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:infoLabel];
    
    UILabel *line        = [[UILabel alloc] initWithFrame:CGRectMake(10, infoLabel.frame.origin.y +infoLabel.frame.size.height, SCREEN_BOUNDS.size.width-20, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, line.frame.origin.y + line.frame.size.height, SCREEN_BOUNDS.size.width, 40)];
    buttonLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:buttonLabel];
    
    likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonLabel.frame.size.width/2, buttonLabel.frame.size.height)];
    [likeBtn addTarget:self action:@selector(likePress:) forControlEvents:UIControlEventTouchUpInside];
    likeBtn.tag = 0;
    for (id obj in [data objectForKey:@"likeList"])
    {
        if([obj isEqualToString:[[PMUtility sharedInstance] userToken]]){
            likeBtn.tag = 1;
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
    
    UILabel *line2        = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonLabel.frame.origin.y +buttonLabel.frame.size.height, SCREEN_BOUNDS.size.width, 4)];
    line2.backgroundColor = [UIColor colorWithWhite:0.798 alpha:1.000];;
    [self.contentView addSubview:line2];
    
}

- (void)likePress:(UIButton *)sender
{
    NSMutableArray *likeList = [[NSMutableArray alloc] init];
    likeList = [[dataDic objectForKey:@"likeList"] mutableCopy];
    if(sender.tag == 1){
        [likeList removeObject:[[PMUtility sharedInstance] userToken]];
    }else{
        [likeList addObject:[[PMUtility sharedInstance] userToken]];
    }
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
    [query getObjectInBackgroundWithId:[dataDic objectForKey:@"id"]
                                 block:^(PFObject *postObject, NSError *error) {
                                     if(sender.tag == 1){
                                         [postObject incrementKey:@"likecount" byAmount:@-1];
                                     }else{
                                         [postObject incrementKey:@"likecount"];
                                     }
                                     
                                     postObject[@"likeList"] = likeList;
                                     [postObject saveInBackground];
                                 }];
}

- (void)messagePress:(UIButton *)sender
{
    if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(openMessagePage:)]){
        
        [_cellDelegate openMessagePage:sender.tag];
        
    }

}

@end
