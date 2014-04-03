//
//  GTDirectionsViewController.m
//  GTLocationDemo
//
//  Created by Gianluca Tranchedone on 02/04/2014.
//  Copyright (c) 2014 Gianluca Tranchedone. All rights reserved.
//

#import <GTLocation/GTLocation.h>

#import "GTDirectionsViewController.h"
#import "GTMapViewController.h"

@interface GTDirectionsViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, GTMapViewControllerDelegate>

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) CLLocation *startLocation;
@property (nonatomic, strong) CLLocation *endLocation;
@property (nonatomic, strong) GTRoute *route;

@property (nonatomic, weak) id locationRequester;
@property (nonatomic, weak) MKPolyline *routePolyline;

@property (nonatomic, weak) IBOutlet UIButton *toLocationButton;
@property (nonatomic, weak) IBOutlet UIButton *fromLocationButton;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation GTDirectionsViewController

#pragma mark - Superclass Methods Override -
#pragma mark View Lifecycle

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.operationQueue cancelAllOperations];
}

#pragma mark Nagivation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[GTMapViewController class]]) {
        GTMapViewController *mapViewController = segue.destinationViewController;
        mapViewController.showsDoneButton = YES;
        mapViewController.delegate = self;
        self.locationRequester = sender;
    }
}

#pragma mark - Private APIs -

- (void)loadDirections
{
    GTGoogleDirectionsOperation *operation = [[GTGoogleDirectionsOperation alloc] initWithStartLocation:self.startLocation
                                                                                            destination:self.endLocation
                                                                                             travelMode:GTTravelModeTransit];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(operation) weakOperation = operation;
    
    [operation setCompletionBlock:^{
        __strong GTGoogleDirectionsOperation *strongOperation = weakOperation;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (strongOperation) {
                if (strongOperation.error) {
                    [weakSelf showAlertForError:strongOperation.error];
                }
                else if (!strongOperation.availableRoutes.count) {
                    [weakSelf showNoRoutesFoundAlert];
                }
                else {
                    weakSelf.route = [strongOperation.availableRoutes firstObject];
                }
            }
        });
    }];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.operationQueue addOperation:operation];
}

- (void)displayRouteOnMap:(GTRoute *)route
{
    if (self.routePolyline) {
        [self.mapView removeOverlay:self.routePolyline];
    }
    
    if (route) {
        NSUInteger stepsCount = route.steps.count;
        CLLocationCoordinate2D coordinates[stepsCount];
        memset(coordinates, 0, stepsCount * sizeof(CLLocationCoordinate2D));
        
        for (int i = 0; i < stepsCount; i++) {
            GTRouteStep *step = route.steps[i];
            coordinates[i] = step.startLocation.coordinate;
        }
        
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:stepsCount];
        MKMapRect rect = [self.mapView mapRectThatFits:polyline.boundingMapRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20)];
        
        [self.mapView setVisibleMapRect:rect animated:YES];
        [self.mapView addOverlay:polyline];
        [self setRoutePolyline:polyline];
    }
}

- (void)showAlertForError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred"
                                                        message:[error.userInfo objectForKey:NSLocalizedDescriptionKey]
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)showNoRoutesFoundAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No routes found"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - MKMapViewDelegate -

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.fillColor   = self.mapView.tintColor;
        renderer.strokeColor = self.mapView.tintColor;
        renderer.lineWidth   = 3;
        
        return renderer;
    }
    else {
        return nil;
    }
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.route.steps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTRouteStep *routeStep = [self.route.steps objectAtIndex:indexPath.row];
    NSDictionary *lineDictionary = [routeStep.travelInfo objectForKey:@"line"];
    NSDictionary *vehicleDictionary = [lineDictionary objectForKey:@"vehicle"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = routeStep.instructions;
    cell.textLabel.numberOfLines = 0;
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.image = nil;
    
    if (vehicleDictionary) {
        NSString *urlString = nil;
        if ([vehicleDictionary objectForKey:@"local_icon"]) {
            urlString = [vehicleDictionary objectForKey:@"local_icon"];
        }
        else {
            urlString = [vehicleDictionary objectForKey:@"icon"];
        }
        
        if (urlString) {
            NSURL *queryURL = [NSURL URLWithString:[NSString stringWithFormat:@"http:%@", urlString]];
            NSURLRequest *request = [NSURLRequest requestWithURL:queryURL cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10.0];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if ([[tableView cellForRowAtIndexPath:indexPath] isEqual:cell]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UITableViewCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
                        UIImage *image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
                        if ([theCell isEqual:cell] && image) {
                            theCell.imageView.image = image;
                            
                            // relayout the cell to add and lay out the imageView to the cell's content view if needed
                            // cells created with Storyboard don't seem to have the image added as subview by default
                            if (!theCell.imageView.superview) {
                                [theCell setNeedsLayout];
                            }
                        }
                    });
                }
            }];
            [task resume];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = tableView.rowHeight;
    GTRouteStep *routeStep = [self.route.steps objectAtIndex:indexPath.row];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:[UIFont labelFontSize]]};
    
    CGRect instructionsRect = [routeStep.instructions boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:attributes
                                               context:nil];
    CGFloat instructionsHeight = ceilf(instructionsRect.size.height);
    
    if ((instructionsHeight + 20) > rowHeight) {
        rowHeight = (instructionsHeight + 20);
    }
    
    return rowHeight;
}

#pragma mark - GTMapViewControllerDelegate -

- (void)mapViewController:(GTMapViewController *)controller didFinishWithLocation:(CLLocation *)location name:(NSString *)name
{
    if ([self.locationRequester isEqual:self.fromLocationButton]) {
        self.startLocation = location;
    }
    else {
        self.endLocation = location;
    }
    
    [self.locationRequester setTitle:name forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
    [self setLocationRequester:nil];
    
    if (self.startLocation && self.endLocation) {
        [self loadDirections];
    }
}

#pragma mark - Setters and Getters -

- (void)setRoute:(GTRoute *)route
{
    _route = route;
    
    [self.tableView reloadData];
    [self displayRouteOnMap:route];
}

- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue) {
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.name = @"Directions Operation Queue";
        operationQueue.maxConcurrentOperationCount = 5;
        
        self.operationQueue = operationQueue;
    }
    
    return _operationQueue;
}

@end
