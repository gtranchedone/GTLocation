//
//  GTMapAnnotation.m
//  Pods
//
//  Created by Gianluca Tranchedone on 02/04/2014.
//
//

#import "GTMapAnnotation.h"

@interface GTMapAnnotation ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString *title;

@end

@implementation GTMapAnnotation

- (instancetype)initWithLocation:(CLLocation *)location name:(NSString *)name
{
    self = [super init];
    if (self) {
        self.coordinate = location.coordinate;
        self.title = name;
    }
    return self;
}

@end
