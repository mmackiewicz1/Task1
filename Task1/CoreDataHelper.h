//
//  CoreDataHelper.h
//  Task1
//
//  Created by Marcin Mackiewicz on 11/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject
+ (NSManagedObjectContext *)mainManagedObjectContext;
+ (BOOL)createNewCoordinatesWithLatitude:(float)latitude AndLongitude:(float)longitude;
+ (BOOL)update;
+ (NSArray *)fetchDataWithEntityName:(NSString *)entityName;
+ (BOOL)removeCoreDataObject:(NSManagedObject*)managedObject;
@end