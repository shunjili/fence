//
//  PFViewController.m
//  Paypal Fence
//
//  Created by Shunji Li on 6/7/14.
//  Copyright (c) 2014 Shunji Li. All rights reserved.
//

#import "PFViewController.h"
#import <MapKit/MapKit.h>
#import <ProximityKit/ProximityKit.h>
#import "PFAppDelegate.h"
@interface PFViewController ()<MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *indicatorLabel;

@end

@implementation PFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupNotification];
    [self.titleLabel setText:@"Welcome to Paypal Fence"];
    [self.titleLabel sizeToFit];
    [self.indicatorLabel setText:@"Please update your location"];
    [self.indicatorLabel sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (IBAction)syncPKManager:(id)sender {
    PFAppDelegate *delegate = (PFAppDelegate*) [[UIApplication sharedApplication]delegate];
    [delegate.proximityKitManager sync];
}

- (void) setMapViewRegionForLocation: (CLLocation*) location
{
    MKCoordinateRegion  region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500);
    [self.mapView setRegion:[self.mapView regionThatFits:region]];
    [self.mapView setShowsUserLocation:YES];
}

- (void) setupNotification
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:@"enterRegion" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSString *name = note.userInfo[@"name"];
        CLLocation *location = note.userInfo[@"location"];
        [self setMapViewRegionForLocation:location];
    
        self.titleLabel.text = [NSString stringWithFormat:@"Welcome to %@", name];
        [self.titleLabel sizeToFit];
        [self.indicatorLabel setText:@"Welcome"];
        [self.indicatorLabel sizeToFit];
    }];
    [center addObserverForName:@"exitRegion" object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        PFAppDelegate *appDelegate = (PFAppDelegate*) [[UIApplication sharedApplication] delegate];
        if (!appDelegate.currentRegion)
        {
            NSString *name = note.userInfo[@"name"];
            CLLocation *location = note.userInfo[@"location"];
            [self setMapViewRegionForLocation:location];
            self.titleLabel.text = [NSString stringWithFormat:@"You just exited %@", name];
            [self.titleLabel sizeToFit];
            [self.indicatorLabel setText:@"You are not in Paypal"];
            [self.indicatorLabel sizeToFit];
            
        }

    }];
}

@end
