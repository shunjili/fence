//
//  PFAppDelegate.m
//  Paypal Fence
//
//  Created by Shunji Li on 6/7/14.
//  Copyright (c) 2014 Shunji Li. All rights reserved.
//

#import "PFAppDelegate.h"

@implementation PFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // create and start to sync the manager with the Proximity Kit backend
    self.proximityKitManager = [PKManager managerWithDelegate:self];
    [self.proximityKitManager start];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

- (void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // Called when updating applicaiton data in the background. Requires that UIBackgroundModes contains "fetch" in the applications's Info.plist. See PKExample-Info.plist for an example.
    [self.proximityKitManager syncWithCompletionHandler: completionHandler];
}

#pragma mark- Proximity Kit Delegate Methods
- (void)proximityKitDidSync:(PKManager *)manager {
    NSLog(@"Did Sync");
}
- (void)proximityKit:(PKManager *)manager didEnter:(PKRegion*)region {
    NSLog(@"Entered Region %@ (%@)", region.name, region.identifier);
    CLLocation *location = [manager.locationManager location];
    NSDictionary *info = @{@"name":region.name, @"location":location};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enterRegion" object:self userInfo:info];
    self.currentRegion = region;
    
}

- (void)proximityKit:(PKManager *)manager didExit:(PKRegion *)region {
    NSLog(@"Exit Region %@ (%@)", region.name, region.identifier);

    CLLocation *location = [manager.locationManager location];
    NSDictionary *info = @{@"name":region.name, @"location":location};
    if (self.currentRegion == region) {
        self.currentRegion = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"exitRegion" object:self userInfo:info];
    }
}

//- (void)proximityKit:(PKManager *)manager didRangeBeacons:(NSArray *)ibeacons inRegion:(PKIBeacon *)region
//{
//    for (PKIBeacon *ibeacon in ibeacons) {
//        NSLog(@"Ranged UUID: %@ Major:%ld Minor:%ld RSSI:%ld", [ibeacon.uuid UUIDString], (long)ibeacon.major, (long)ibeacon.minor, (long)ibeacon.rssi);
//    }
//}
//
//- (void)proximityKit:(PKManager *)manager didDetermineState:(PKRegionState)state forRegion:(PKRegion *)region
//{
//    
//    if (state == PKRegionStateInside) {
//        NSLog(@"State Changed: inside region %@ (%@)", region.name, region.identifier);
//    } else if (state == PKRegionStateOutside) {
//        NSLog(@"State Changed: outside region %@ (%@)", region.name, region.identifier);
//    } else if (state == PKRegionStateUnknown) {
//        NSLog(@"State Changed: unknown region %@ (%@)", region.name, region.identifier);
//    }
//}



@end
