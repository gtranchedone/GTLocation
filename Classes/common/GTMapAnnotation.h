//
//  GTMapAnnotation.h
//  Pods
//
//  Created by Gianluca Tranchedone on 02/04/2014.
//
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GTMapAnnotation : NSObject <MKAnnotation>

- (instancetype)initWithLocation:(CLLocation *)location name:(NSString *)name;

@end
