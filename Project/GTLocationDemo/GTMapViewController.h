//
//  GTMapViewController.h
//  GTLocationDemo
//
//  Created by Gianluca Tranchedone on 02/04/2014.
//  Copyright (c) 2014 Gianluca Tranchedone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol GTMapViewControllerDelegate;

@interface GTMapViewController : UIViewController

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, assign) BOOL showsDoneButton; // default is NO
@property (nonatomic, weak) id<GTMapViewControllerDelegate> delegate;

@end

@protocol GTMapViewControllerDelegate <NSObject>

@optional
- (void)mapViewController:(GTMapViewController *)controller didFinishWithLocation:(CLLocation *)location name:(NSString *)name;

@end
