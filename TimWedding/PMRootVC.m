//
//  PMRootVC.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/8.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#define SCREEN_BOUNDS ([[UIScreen mainScreen] bounds])
#import "PMRootVC.h"
#import "PMVideoMainVC.h"

@interface PMRootVC ()

@end

@implementation PMRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    btn.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, ([[UIScreen mainScreen] bounds].size.height - 64)/2);
    [btn setTitle:@"Video" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:16.];
    btn.backgroundColor = [UIColor colorWithRed:0.945 green:0.510 blue:0.000 alpha:1.000];
    [btn addTarget:self action:@selector(btnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnPress
{
    PMVideoMainVC *videoVC = [[PMVideoMainVC alloc] init];
    [self.navigationController pushViewController:videoVC animated:YES];
}

@end
