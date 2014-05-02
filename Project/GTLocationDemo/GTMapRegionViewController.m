//
//  GTMapRegionViewController.m
//  GTLocationDemo
//
//  Created by Gianluca Tranchedone on 03/04/2014.
//  Copyright (c) 2014 Gianluca Tranchedone. All rights reserved.
//

#import "GTMapRegionViewController.h"

@interface GTMapRegionViewController () <MKMapViewDelegate, UISearchBarDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *distanceTextField;

@property (strong, nonatomic) CLLocation *location;

@end

@implementation GTMapRegionViewController

#pragma mark - MKMapViewDelegate -

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
        renderer.fillColor = [self.mapView.tintColor colorWithAlphaComponent:0.5];
        renderer.strokeColor = self.mapView.tintColor;
        
        return renderer;
    }
    else {
        return nil;
    }
}

#pragma mark - UISearchBarDelegate -

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [GTGoogleGeocoder geocodeAddress:searchBar.text withCompletionBlock:^(CLLocation *location, NSError *error) {
        [self.mapView setCenterCoordinate:location.coordinate animated:YES];
        [self setLocation:location];
    }];
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.location.coordinate radius:[textField.text doubleValue]];
    [self.mapView addAnnotation:circle];
    [self.mapView addOverlay:circle];
    
    return YES;
}

@end
