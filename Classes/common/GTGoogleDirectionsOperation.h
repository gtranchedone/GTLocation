//
//  GTGoogleDirectionsOperation.h
//  GTFoundation
//
//  Created by Gianluca Tranchedone on 4/11/13.
//  Copyright (c) 2013 Gianluca Tranchedone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, GTTravelMode) {
    GTTravelModeWalking,
    GTTravelModeCycling,
    GTTravelModeTransit,
    GTTravelModeDriving
};

@interface GTGoogleDirectionsOperation : NSOperation

+ (instancetype)operationWithStartLocation:(CLLocation *)origin destination:(CLLocation *)destination travelMode:(GTTravelMode)travelMode;
- (instancetype)initWithStartLocation:(CLLocation *)origin destination:(CLLocation *)destination travelMode:(GTTravelMode)travelMode;

@end
