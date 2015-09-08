//
//  PMVideoMainVC.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/8.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#define SCREEN_BOUNDS ([[UIScreen mainScreen] bounds])

#import "PMVideoMainVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <pop/POP.h>

@interface PMVideoMainVC ()
@property (strong, nonatomic) MPMoviePlayerController *player;
@end

@implementation PMVideoMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    self.player.scalingMode = MPMovieScalingModeAspectFill;
    self.player.repeatMode = MPMovieRepeatModeOne;
    self.player.controlStyle = MPMovieControlStyleNone;
    //    player.view.frame = self.view.bounds;
    self.player.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    self.player.view.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2);
    [self.view addSubview:self.player.view];
    [self.player prepareToPlay];
    [self.player play];
    
    
    UIView *blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height)];
//    blurView.backgroundColor = [UIColor blackColor];
//    blurView.alpha = 0.7;
    
    blurView.backgroundColor = [UIColor whiteColor];
    blurView.alpha = 0.5;
    
    [self.view addSubview:blurView];
    //    UIVisualEffect *blurEffect;
    //    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //
    //    UIVisualEffectView *visualEffectView;
    //    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //
    //    visualEffectView.frame = self.player.view.bounds;
    //    [self.player.view addSubview:visualEffectView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_BOUNDS.size.width, 40)];
    titleLabel.text = @"POM & MIKI";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40.];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(startTimeline) userInfo:nil repeats:NO];
    
    
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
    UIView *circleView1;
    
    if(lastView == nil){
        
        circleView1 = [self circleView:CGRectMake(40,120,20,20) upperView:nil];
    }else{
        i = count;
        circleView1 = [self circleView:CGRectMake(0,0,20,20) upperView:lastView];
    }
    
    if(i > 4){
        return ;
    }
    
    [self.view addSubview:circleView1];
    UIView *squareView1 = [self squareWithUpperView:circleView1];
    [self.view addSubview:squareView1];
    
    circleView1.transform = CGAffineTransformMakeScale(0.1,0.1);
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    scaleAnimation.springBounciness = 15.f;
    [circleView1.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{

            if(i < 4){
                squareView1.frame = CGRectMake(circleView1.center.x-2.5, circleView1.frame.origin.y + circleView1.frame.size.height, 5, 50);
            }
            
        } completion:^(BOOL finished) {
            i = i+1;
            [self timelineView:squareView1 count:i];
            
        }];
        
    };

}

- (UIView *)circleView:(CGRect)frame upperView:(UIView *)upperView
{
    UIView *circleView;
    if(upperView == nil){
        circleView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x
                                                                      ,frame.origin.y,frame.size.width,frame.size.height)];
    }else{
        circleView = [[UIView alloc] initWithFrame:CGRectMake(upperView.center.x - frame.size.width/2
                                                              ,upperView.frame.origin.y + upperView.frame.size.height,frame.size.width,frame.size.height)];
    }
    
    circleView.alpha = 0.5;
    circleView.layer.cornerRadius = 10;
    circleView.backgroundColor = [UIColor colorWithRed:0.945 green:0.510 blue:0.000 alpha:1.000];
    
    return circleView;
}

- (UIView *)squareWithUpperView:(UIView *)upperView
{
    UIView *squareView = [[UIView alloc] initWithFrame:CGRectMake(upperView.center.y - 2.5, upperView.frame.origin.y + upperView.frame.size.height-10, 5, 0)];
    squareView.center = CGPointMake(upperView.center.x, squareView.center.y+9);
    squareView.backgroundColor = [UIColor colorWithRed:0.945 green:0.510 blue:0.000 alpha:1.000];
    squareView.alpha = 0.5;
    return squareView;
}

@end
