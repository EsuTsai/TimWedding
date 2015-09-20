//
//  PMVideoMainVC.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/8.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//


#import "PMVideoMainVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPVolumeView.h>
#import <pop/POP.h>
#import "IDMPhotoBrowser.h"

@interface PMVideoMainVC () <IDMPhotoBrowserDelegate>
{
    UIScrollView *backgroundView;
}

@property (strong, nonatomic) MPMoviePlayerController *player;
@end

@implementation PMVideoMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];

    self.player              = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.player.scalingMode  = MPMovieScalingModeAspectFill;
    self.player.repeatMode   = MPMovieRepeatModeOne;
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.view.frame   = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-49);
    self.player.view.center  = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, ([[UIScreen mainScreen] bounds].size.height-49)/2);
    [self.view addSubview:self.player.view];
//    [self.player prepareToPlay];
    [self.player play];
    
    
    UIView *layerView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height)];
    layerView.backgroundColor = [UIColor colorWithWhite:0.153 alpha:1.000];
    layerView.alpha           = 0.6;
//  layerView.backgroundColor = [UIColor whiteColor];
//  layerView.alpha = 0.3;
    [self.view addSubview:layerView];
    
    backgroundView                              = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height)];
    backgroundView.scrollEnabled                = YES;
    backgroundView.contentSize                  = CGSizeMake(SCREEN_BOUNDS.size.width, 1150);
    backgroundView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backgroundView];
    //    UIVisualEffect *blurEffect;
    //    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //
    //    UIVisualEffectView *visualEffectView;
    //    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //
    //    visualEffectView.frame = self.player.view.bounds;
    //    [self.player.view addSubview:visualEffectView];
    
    UILabel *titleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_BOUNDS.size.width, 40)];
    titleLabel.text          = @"POM & MIKI";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font          = [UIFont fontWithName:defaultFont size:40.];
    titleLabel.textColor     = [UIColor whiteColor];
    [backgroundView addSubview:titleLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(startTimeline) userInfo:nil repeats:NO];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.player play];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.player pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startTimeline
{
    [self timelineView:nil count:0];
}

- (void)timelineView:(UIView *)lastView count:(int)count
{
    __block int i = 0;
    UIImageView *circleView1;
    
    if(lastView == nil){
        circleView1 = [self circleView:CGRectMake(40,120,60,60) upperView:nil imageCount:i];
    }else{
        i = count;
        circleView1 = [self circleView:CGRectMake(0,0,60,60) upperView:lastView imageCount:i];
    }
    
    if(i > 8){
        return ;
    }
    
    [backgroundView addSubview:circleView1];
    UIView *squareView1 = [self squareWithUpperView:circleView1];
    [backgroundView addSubview:squareView1];
    
    UIView *infoView = [self infoWithLeftView:circleView1 infoCount:i];
    infoView.alpha = 0.0;
    [backgroundView addSubview:infoView];
    
    circleView1.transform = CGAffineTransformMakeScale(0.1,0.1);
    [UIView animateWithDuration:0.2f animations:^{
        infoView.alpha = 1.0;
    }];
    
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue             = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    scaleAnimation.springBounciness    = 15.f;
    [circleView1.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [UIView animateWithDuration:0.4f animations:^{
            if(i < 8){
                squareView1.frame = CGRectMake(circleView1.center.x-2.5, circleView1.frame.origin.y + circleView1.frame.size.height, 1, 50);
            }
            
        } completion:^(BOOL finished) {
            i = i+1;
            
            [self timelineView:squareView1 count:i];
            
        }];
        
    };

}

- (UIImageView *)circleView:(CGRect)frame upperView:(UIView *)upperView imageCount:(int)count
{
    UIImageView *circleView;
    if(upperView == nil){
        circleView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x
                                                                      ,frame.origin.y,frame.size.width,frame.size.height)];
    }else{
        circleView = [[UIImageView alloc] initWithFrame:CGRectMake(upperView.center.x - frame.size.width/2
                                                              ,upperView.frame.origin.y + upperView.frame.size.height,frame.size.width,frame.size.height)];
    }
    
    [circleView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",count]]];
    circleView.contentMode        = UIViewContentModeScaleAspectFill;
    circleView.clipsToBounds      = YES;
    circleView.tag = count;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage:)];
    [circleView addGestureRecognizer:tapGesture];
    circleView.userInteractionEnabled = YES;
//    circleView.alpha = 0.5;
    circleView.layer.cornerRadius = 30;
    circleView.backgroundColor    = [UIColor colorWithRed:0.945 green:0.510 blue:0.000 alpha:1.000];
    
    return circleView;
}

- (UIView *)squareWithUpperView:(UIImageView *)upperView
{
    UIView *squareView         = [[UIView alloc] initWithFrame:CGRectMake(upperView.center.y - 2.5, upperView.frame.origin.y + upperView.frame.size.height-10, 1, 0)];
    squareView.center          = CGPointMake(upperView.center.x, squareView.center.y+9);
//    squareView.backgroundColor = [UIColor colorWithRed:0.945 green:0.510 blue:0.000 alpha:1.000];
    squareView.backgroundColor = [UIColor lightGrayColor];
    squareView.alpha           = 0.5;
    return squareView;
}

- (UIView *)infoWithLeftView:(UIView *)leftView infoCount:(int)count
{
    NSArray *yearArray = @[@"1982",
                           @"1984",
                           @"1985",
                           @"1986",
                           @"周家全家福",
                           @"賴家全家福",
                           @"2006.1.1 紀念日",
                           @"2015.11.1 Wedding",
                           @"2015.11.1 Wedding"];
    
    NSArray *wordArray = @[@"周先生．鄧小姐 - 締結良緣\n揭開了周公館家歡樂生活的布幕",
                           @"周廷俊\n帶著有點靦腆及幽默、溫和的個性來到這個世上",
                           @"賴先生．張小姐 - 成家之始\n開起了賴家歡喜人生的大門",
                           @"賴佳玟\n用有點好奇、 迷糊的個性以及甜滋滋的笑容，誕生了",
                           @"一家五口，個性皆隨和風趣且獨立，雖然平時不會將肉麻的句子掛在嘴邊，但也是深深信任著每位家人",
                           @"一家四口，一起相互扶持，雖然日子簡單、樸實，但家人永遠是最溫馨的避風港",
                           @"一個色眯眯的周胖\n一個水噹噹的米奇\n在這天成為人人稱羨的一對情侶",
                           @"走過近10年的日子\n我們決定給彼此一輩子的幸福",
                           @"我們挽著手，並肩同行於我們生命新頁中的每一天"];
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(leftView.frame.origin.x + leftView.frame.size.width + 20, leftView.frame.origin.y, SCREEN_BOUNDS.size.width - leftView.frame.origin.x - leftView.frame.size.width - 20-10, leftView.frame.size.height + 50)];
        
    UILabel *yearLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, infoView.frame.size.width, 22)];
    yearLabel.text      = [NSString stringWithFormat:@"%@",[yearArray objectAtIndex:count]];
    yearLabel.textColor = [UIColor whiteColor];
    yearLabel.font      = [UIFont fontWithName:defaultFont size:20.];
    [infoView addSubview:yearLabel];
    
    UILabel *wordLabel            = [[UILabel alloc] initWithFrame:CGRectMake(0, yearLabel.frame.origin.y + yearLabel.frame.size.height +2, infoView.frame.size.width, 60)];
    wordLabel.text                = [NSString stringWithFormat:@"%@",[wordArray objectAtIndex:count]];
    wordLabel.textColor           = [UIColor whiteColor];
    wordLabel.font                = [UIFont fontWithName:defaultFont size:14.];
    wordLabel.numberOfLines       = 0;
    wordLabel.layer.shadowColor   = [UIColor blackColor].CGColor;
    wordLabel.layer.shadowOffset  = CGSizeMake(3.0, 3.0);
    wordLabel.layer.shadowRadius  = 3.0;
    wordLabel.layer.shadowOpacity = 1.0;
    [infoView addSubview:wordLabel];
    
    
    return infoView;
}

- (void)didTapImage:(UITapGestureRecognizer *)tapGesture
{
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    IDMPhoto *photo;
    NSMutableArray *photos = [NSMutableArray new];
    photo = [IDMPhoto photoWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long)tapGesture.view.tag]]];
    [photos addObject:photo];
    
    IDMPhotoBrowser *browser;
    browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:tapGesture.view];
    browser.scaleImage = imageView.image;
    browser.delegate = self;
    browser.displayCounterLabel = NO;
    browser.displayActionButton = NO;
    browser.displayArrowButton = NO;
    browser.usePopAnimation = YES;
    
    [self presentViewController:browser animated:NO completion:nil];
    
}


@end
