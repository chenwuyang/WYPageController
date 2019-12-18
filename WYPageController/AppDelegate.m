//
//  AppDelegate.m
//  WYPageController
//
//  Created by 陈午阳 on 2019/12/18.
//  Copyright © 2019 陈午阳. All rights reserved.
//

#import "AppDelegate.h"
#import "WYPageController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.window makeKeyAndVisible];

    WYPageController *wyPageVC = [[WYPageController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:wyPageVC];
    navVC.title = @"首页";
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[navVC];
    self.window.rootViewController = tabBarController;
    return YES;

}



@end
