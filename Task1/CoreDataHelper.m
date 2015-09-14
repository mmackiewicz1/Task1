//
//  CoreDataHelper.m
//  Task1
//
//  Created by Marcin Mackiewicz on 11/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "Coordinates.h"

@interface CoreDataHelper ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation CoreDataHelper

#pragma mark - Main NSManagedObjectContext setup

+ (NSManagedObjectContext *)mainManagedObjectContext {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return delegate.managedObjectContext;
}

+ (BOOL)createNewCoordinatesWithLatitude:(float)latitude AndLongitude:(float)longitude{
    BOOL result = NO;

    Coordinates *newCoordinates = [NSEntityDescription insertNewObjectForEntityForName:@"Coordinates"
                             inManagedObjectContext:[self mainManagedObjectContext]];
    
    if (newCoordinates == nil){
        NSLog(@"Failed to create the new Coordinates.");
        return NO;
    }
    newCoordinates.longitude = [NSNumber numberWithFloat: longitude];
    newCoordinates.latitude = [NSNumber numberWithFloat: latitude];
    NSError *savingError = nil;
    if ([[self mainManagedObjectContext] save:&savingError]){
        result = YES;
    } else {
        NSLog(@"Failed to save the new Coordinates. Error = %@", savingError);
    }
    return result;
}

+ (BOOL)update {
    BOOL result = NO;
    NSError *savingError = nil;
    if ([[self mainManagedObjectContext] save:&savingError]){
        result = YES;
    } else {
        NSLog(@"Failed to save the new Coordinates. Error = %@", savingError);
    }
    return result;
}

+ (NSArray *)fetchDataWithEntityName:(NSString *)entityName {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSError *requestError = nil;
    
    return [[self mainManagedObjectContext] executeFetchRequest:fetchRequest error:&requestError];
}

+ (BOOL)removeCoreDataObject:(NSManagedObject*)managedObject {
    [[self mainManagedObjectContext] deleteObject:managedObject];
    NSError *savingError = nil;
    if ([[self mainManagedObjectContext] save:&savingError]){
        NSLog(@"Successfully deleted.");
    } else {
        NSLog(@"Failed to delete.");
    }
    return YES;
}

@end
