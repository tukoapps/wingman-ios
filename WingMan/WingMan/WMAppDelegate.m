//
//  WMAppDelegate.m
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import "WMAppDelegate.h"
#import "WMHomeTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "WMRestKitManager.h"
#import "WMUser.h"

@implementation WMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WMUser user];
    [WMRestKitManager sharedManager];
    NSTimeInterval fifteenMinutes = 15 * 60;
    [NSTimer scheduledTimerWithTimeInterval:fifteenMinutes target:[WMRestKitManager sharedManager] selector:@selector(updateUserLocation) userInfo:nil repeats:YES];
    [self setRootViewController];
    return YES;
}

-(void)setRootViewController
{
    // check if the user is on an iPad or iPhone
    NSString *storyboardName;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboardName = @"Main_iPad";
    } else {
        storyboardName = @"Main_iPhone";
    }    // Override point for customization after application launch.
    [FBLoginView class];
    NSString *accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSLog(@"%@", accessToken);
    // bypass login screen if user is already logged in
    if (accessToken) {
        WMHomeTableViewController *home = [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:@"home"];
        self.window.rootViewController = home;
        [[WMUser user] userLoggedIn];
    }   
}

-(void)didLogOut
{
    [self.window setRootViewController:[[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"login"]];
    [[FBSession activeSession] closeAndClearTokenInformation];
    [[WMUser user] userLoggedOut];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    return wasHandled;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
