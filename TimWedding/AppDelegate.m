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
#import "PMFeedVC.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import <Parse/Parse.h>
#import "NSString+Hash.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:78.0/255.0 green:139.0/255.0 blue:115.0/255.0 alpha:1.000]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navigationController = nil;
    navigationController = [[UINavigationController alloc] initWithRootViewController:[self rootViewController]];
    navigationController.navigationBar.translucent = NO;    
    
    [Parse setApplicationId:@"rqRfR8SaRL64yqhFO4LAUSZn4yVum5w7TS5uJKCC"
                  clientKey:@"lJocu95bQQhJaFm3MiQEDnRZMrPUgAXqKCrFcYd6"];
    
    NSUserDefaults *userDefaults = USER_DEFAULTS;
    if (![userDefaults valueForKey:kUserToken]){
        NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
        NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *str = [[NSString stringWithFormat:@"%@,%@",timestamp,uuid] MD5];
        [userDefaults setObject:str forKey:kUserToken];
        [userDefaults synchronize];
    }
    self.window.rootViewController = [self setTabbar];
    [self.window makeKeyAndVisible];

    
#ifdef DEBUG
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *folder = [path objectAtIndex:0];
    NSLog(@"Your NSUserDefaults are stored in this folder: %@/Preferences", folder);
#endif
    
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

- (UITabBarController *)setTabbar
{
    PMFeedVC *feedVC = [[PMFeedVC alloc] init];
    UINavigationController *navController0 = [[UINavigationController alloc] initWithRootViewController:feedVC];
    FAKIonIcons *feedIcon = [FAKIonIcons chatbubbleWorkingIconWithSize:28];
    [feedIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *deFeedImage = [[feedIcon imageWithSize:CGSizeMake(28, 28)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *feedImage = [feedIcon imageWithSize:CGSizeMake(28, 28)];
    UITabBarItem *item0 = [[UITabBarItem alloc] initWithTitle:nil image:deFeedImage tag:1];
    feedVC.tabBarItem = item0;
    feedVC.tabBarItem.selectedImage = feedImage;
    feedVC.tabBarItem.imageInsets= UIEdgeInsetsMake(5, 0, -5, 0);
    
    PMPhotoVC *photoVC = [[PMPhotoVC alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoVC];
    FAKIonIcons *photoIcon = [FAKIonIcons imagesIconWithSize:28];
    [photoIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *dePhotoImage = [[photoIcon imageWithSize:CGSizeMake(28, 28)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *photoImage = [photoIcon imageWithSize:CGSizeMake(28, 28)];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:nil image:dePhotoImage tag:1];
    photoVC.tabBarItem = item1;
    photoVC.tabBarItem.selectedImage = photoImage;
    photoVC.tabBarItem.imageInsets= UIEdgeInsetsMake(5, 0, -5, 0);
    
    
    PMVideoMainVC *videoVC = [[PMVideoMainVC alloc] init];
    FAKIonIcons *bookIcon = [FAKIonIcons wineglassIconWithSize:28];
    [bookIcon addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor]];
    UIImage *deVideoImage = [[bookIcon imageWithSize:CGSizeMake(28, 28)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *videoImage = [bookIcon imageWithSize:CGSizeMake(28, 28)];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:nil image:deVideoImage tag:2];
    videoVC.tabBarItem = item2;
    videoVC.tabBarItem.selectedImage = videoImage;
    videoVC.tabBarItem.imageInsets= UIEdgeInsetsMake(5, 0, -5, 0);
    
    NSArray *viewController = @[navController0,navController,videoVC];
    UITabBarController *tabView = [[UITabBarController alloc] init];
    tabView.viewControllers = viewController;
    tabView.tabBar.barTintColor =  [UIColor whiteColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor clearColor],
                                                         NSFontAttributeName: [UIFont fontWithName:defaultFont size:12]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor clearColor]}
                                             forState:UIControlStateSelected];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.235 green:0.423 blue:0.353 alpha:1.000]];
    tabView.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    return tabView;
}

@end
