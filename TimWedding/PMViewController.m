//
//  PMViewController.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/8.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "PMViewController.h"
#import "PMVideoMainVC.h"

@interface PMViewController ()

@end

@implementation PMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationBarStyle];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:![self shouldShowNavigationBar] animated:YES];
//    [[UIApplication sharedApplication] setStatusBarStyle:[self preferredStatusBarStyle] animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationBarStyle
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIImage *image = [UIImage imageNamed:@"navbarbg.png"];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    // Setting All NavgationBar Title
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIFont fontWithName:@"Avenir-Light" size:16.],
                                    NSFontAttributeName
                                    ,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
}

#pragma mark -
- (BOOL)shouldShowNavigationBar
{
    return YES;
}

- (BOOL)shouldShowStatusBar
{
    return YES;
}

@end
