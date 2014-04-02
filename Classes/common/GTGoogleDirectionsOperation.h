//
//  GTGoogleDirectionsOperation.h
//  GTLocation
//
//  Created by Gianluca Tranchedone http://gtranchedone.com
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Gianluca Tranchedone
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "GTRoute.h"

@interface GTGoogleDirectionsOperation : NSOperation

///-------------------------------------------------------
/// @name Setting the direction's query's optional values
///-------------------------------------------------------

@property (nonatomic, assign) BOOL findAlternativeRoutes; // default YES
@property (nonatomic, strong) NSDate *departureTime; // when not set is [NSDate date]
@property (nonatomic, strong) NSDate *arrivalTime;

///-------------------------------------------------------
/// @name Getting the operation's configuration values
///-------------------------------------------------------

@property (nonatomic, readonly, strong) CLLocation *origin;
@property (nonatomic, readonly, strong) CLLocation *destination;
@property (nonatomic, readonly, assign) GTTravelMode travelMode;

///-------------------------------------------------------
/// @name Getting the operation's results
///-------------------------------------------------------

@property (nonatomic, readonly, copy) NSError *error;
@property (nonatomic, readonly, copy) NSArray *availableRoutes;

///-------------------------------------------------------
/// @name Creating a directions operation
///-------------------------------------------------------

+ (instancetype)operationWithStartLocation:(CLLocation *)origin destination:(CLLocation *)destination travelMode:(GTTravelMode)travelMode;
- (instancetype)initWithStartLocation:(CLLocation *)origin destination:(CLLocation *)destination travelMode:(GTTravelMode)travelMode;

@end
