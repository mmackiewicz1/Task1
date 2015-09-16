//
//  MapViewController.m
//  Task1
//
//  Created by Marcin Mackiewicz on 11/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import "MapViewController.h"
#import "Annotation.h"
#import "Coordinates.h"
#import "CoreDataHelper.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController

/**
 *  Initializes the object without parameters
 *
 *  @return instance object.
 */
- (id)init {
    self = [super init];
    self.title = @"Map";
    return self;
}

/**
 *  Invoked when the view loads for the first time.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapPress:)];
    longPressGesture.minimumPressDuration = 0.1;
    [self.mapView addGestureRecognizer:longPressGesture];
    [self loadCoordinates];
}

/**
 *  Invoked when object receives memory warning.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Invoked when the view appears
 *
 *  @param animated If view is supposed to be animated
 */
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self loadCoordinates];
}

/**
 *  Loads the coordinates from the database and puts them on the map along with the annotations.
 */
- (void) loadCoordinates {
    NSArray *coordinatesList = [CoreDataHelper fetchDataWithEntityName:@"Coordinates"];
    for (Coordinates *coordinateEntity in coordinatesList) {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [coordinateEntity.latitude doubleValue];
        coordinate.longitude = [coordinateEntity.longitude doubleValue];
        Annotation *annotation = [[Annotation alloc] initWithCoordinates:coordinate
                                                                   title:[NSString stringWithFormat:@"Lat: %f Lon: %f", coordinate.latitude, coordinate.longitude] subTitle:nil];
        [self.mapView addAnnotation:annotation];
    }
}

/**
 *  Invoked the map is pressed. Inserts coordinate data into database and puts a pin on the map. The pin is placed where the click was performed.
 */
- (void)mapPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        CGPoint touchLocation = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchLocation toCoordinateFromView:self.mapView];
        Annotation *annotation = [[Annotation alloc] initWithCoordinates:coordinate
                                                                   title:[NSString stringWithFormat:@"%f %f", coordinate.latitude, coordinate.longitude]
                                                                subTitle:[NSString stringWithFormat:@"%f %f", coordinate.latitude, coordinate.longitude]];
        
        BOOL result = [CoreDataHelper createNewCoordinatesWithLatitude:coordinate.latitude AndLongitude:coordinate.longitude];
        if (result) {
            [self.mapView addAnnotation:annotation];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
