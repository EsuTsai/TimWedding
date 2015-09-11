//
//  AppDelegate.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/8.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "AppDelegate.h"
#import "PMRootVC.h"
#import "PMVideoMainVC.h"
#import "PMPhotoVC.h"
#import <FontAwesomeKit/FontAwesomeKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.133 green:0.133 blue:0.133 alpha:1.000]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navigationController = nil;
    navigationController = [[UINavigationController alloc] initWithRootViewController:[self rootViewController]];
    
    PMPhotoVC *photoVC = [[PMPhotoVC alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoVC];
    FAKIonIcons *photoIcon = [FAKIonIcons imagesIconWithSize:22];
    [photoIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    UIImage *photoImage = [photoIcon imageWithSize:CGSizeMake(22, 22)];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"婚紗" image:photoImage tag:1];
    photoVC.tabBarItem = item1;
    
    
    PMVideoMainVC *videoVC = [[PMVideoMainVC alloc] init];
    FAKIonIcons *bookIcon = [FAKIonIcons icecreamIconWithSize:22];
    [bookIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    UIImage *videoImage = [bookIcon imageWithSize:CGSizeMake(22, 22)];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"周胖米奇故事" image:videoImage tag:2];
    videoVC.tabBarItem = item2;
    
    NSArray *viewController = @[navController,videoVC];
    UITabBarController *tabView = [[UITabBarController alloc] init];
    tabView.viewControllers = viewController;
    tabView.tabBar.barTintColor =  [UIColor colorWithRed:0.133 green:0.133 blue:0.133 alpha:1.000];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor],
        NSFontAttributeName: [UIFont fontWithName:defaultFont size:12]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.925 green:0.957 blue:0.569 alpha:1.000]}
                                             forState:UIControlStateSelected];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.925 green:0.957 blue:0.569 alpha:1.000]];
    self.window.rootViewController = tabView;
    [self.window makeKeyAndVisible];

    
    return YES;
}

- (UIViewController *)rootViewController
{
    PMRootVC *rootVC = [[PMRootVC alloc] initWithNibName:@"PMRootVC" bundle:nil];
    
    return rootVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
