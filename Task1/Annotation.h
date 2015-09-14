//
//  Annotation.h
//  Task1
//
//  Created by Marcin Mackiewicz on 11/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject<MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;
- (instancetype) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle
                            subTitle:(NSString *)paramSubTitle;
@end
