//
//  GTMapViewController.m
//  GTLocationDemo
//
//  Created by Gianluca Tranchedone on 02/04/2014.
//  Copyright (c) 2014 Gianluca Tranchedone. All rights reserved.
//

#import <GTLocation/GTLocation.h>
#import "GTMapViewController.h"

@interface GTMapViewController () <UISearchBarDelegate, MKMapViewDelegate>

@property (nonatomic, copy) NSString *currentSearchString;
@property (nonatomic, strong) CLLocation *selectedLocation;

@end

@implementation GTMapViewController

#pragma mark - Superclass Methods Override -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.showsDoneButton) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(doneButtonPressed:)];
    }
}

#pragma mark - Private APIs -

- (void)doneButtonPressed:(UIBarButtonItem *)sender
{
    if ([self.delegate respondsToSelector:@selector(mapViewController:didFinishWithLocation:name:)]) {
        [self.delegate mapViewController:self didFinishWithLocation:self.selectedLocation name:self.currentSearchString];
    }
}

#pragma mark - UISearchBarDelegate -

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchString = searchBar.text;
    __weak typeof(self) weakSelf = self;
    
    [searchBar resignFirstResponder];
    [self setCurrentSearchString:searchString];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [GTGoogleGeocoder searchLocationsMatchingAddress:searchString nearLocation:self.mapView.userLocation.location apiKey:@"" completionBlock:^(NSArray *results, NSError *error) {
        if ([searchString isEqualToString:weakSelf.currentSearchString]) {
		    CLLocation *location = [results firstObject];
		    if (location) {
			    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, location.altitude, location.altitude);
                
			    [weakSelf setSelectedLocation:location];
			    [weakSelf.mapView setRegion:region animated:YES];
			    [weakSelf.mapView addAnnotation:[[GTMapAnnotation alloc] initWithLocation:location name:searchString]];
		    }
	    }
    }];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    else if ([annotation isKindOfClass:[GTMapAnnotation class]]) {
        // try to dequeue an existing pin view first
        static NSString *AnnotationIdentifier = @"AnnotationIdentifier";
        MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
        if (!pinAnnotation) {
            pinAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        }
        
        pinAnnotation.pinColor = MKPinAnnotationColorRed;
        pinAnnotation.canShowCallout = YES;
        pinAnnotation.animatesDrop = YES;
        
        return pinAnnotation;
    }
    
    return nil;
}

@end
