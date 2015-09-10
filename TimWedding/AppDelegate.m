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
    
    PMRootVC *rootVC = [[PMRootVC alloc] initWithNibName:@"PMRootVC" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    PMVideoMainVC *videoVC = [[PMVideoMainVC alloc] init];
    NSArray *viewController = @[navController,videoVC];
    UITabBarController *tabView = [[UITabBarController alloc] init];
    tabView.viewControllers = viewController;
    
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
