//
//  PMRootVC.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/8.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "PMRootVC.h"
#import "PMVideoMainVC.h"
#import "PMPhotoVC.h"

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
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y + btn.frame.size.height+10, btn.frame.size.width, btn.frame.size.height)];
    [btn1 setTitle:@"Photo" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:16.];
    btn1.backgroundColor = [UIColor colorWithRed:0.922 green:0.098 blue:0.176 alpha:1.000];
    [btn1 addTarget:self action:@selector(btn1Press) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
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

- (void)btn1Press
{
    PMPhotoVC *photoVC = [[PMPhotoVC alloc] init];
    [self.navigationController pushViewController:photoVC animated:YES];
}

@end
