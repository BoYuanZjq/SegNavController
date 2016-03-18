//
//  AppDelegate.m
//  SegNavController
//
//  Created by jianqiangzhang on 16/3/19.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "AppDelegate.h"
#import "PaggingViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    PaggingViewController *page = [[PaggingViewController alloc] init];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:2];
    
    NSArray *titles = @[@"最新", @"最热"];
    
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        ViewController *viewController = [[ViewController alloc] init];
        if (idx ==0) {
            viewController.view.backgroundColor = [UIColor redColor];
        }else{
            viewController.view.backgroundColor = [UIColor blueColor];
        }
        [viewControllers addObject:viewController];
    }];
    page.viewControllers = viewControllers;
    page.titles = titles;
    
    page.didChangedPageCompleted = ^(NSInteger cuurentPage) {
        NSLog(@"cuurentPage : %ld", (long)cuurentPage);
    };
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:page]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
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
