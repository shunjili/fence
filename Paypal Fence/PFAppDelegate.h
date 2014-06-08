//
//  PFAppDelegate.h
//  Paypal Fence
//
//  Created by Shunji Li on 6/7/14.
//  Copyright (c) 2014 Shunji Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ProximityKit/ProximityKit.h>

@interface PFAppDelegate : UIResponder <UIApplicationDelegate, PKManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PKManager *proximityKitManager;
@property (strong, nonatomic) PKRegion *currentRegion;
@property (assign, nonatomic) BOOL isInPayPal;
@end
