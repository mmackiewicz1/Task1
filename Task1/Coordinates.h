//
//  Coordinates.h
//  Task1
//
//  Created by Marcin Mackiewicz on 11/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Coordinates : NSManagedObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;

@end
