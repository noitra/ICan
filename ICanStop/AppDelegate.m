//
//  AppDelegate.m
//  ICanStop
//
//  Created by Gabriel Oliva de Oliveira on 3/24/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "RecordeViewController.h"
#import "ConfigViewController.h"

NSString * const CurrentVice = @"CurrentVice";
NSString * const VicesRecords = @"VicesRecords";
NSString * const PreferredNotificationTime = @"PreferredNotificationTime";
NSString * const VicesList = @"VicesList";

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *vicesList = @[@"Nicotina",@"Álcool",@"Drogas"];
    
    [userDefaults setObject:vicesList forKey:VicesList];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HomeViewController *hvc = [[HomeViewController alloc] init];
    RecordeViewController *rvc = [[RecordeViewController alloc] init];
    ConfigViewController *cvc = [[ConfigViewController alloc] init];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[hvc, rvc, cvc];
    
    self.window.rootViewController = tabBarController;
    
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
