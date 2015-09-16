//
//  DetailCoordinatesViewController.h
//  Task1
//
//  Created by Marcin Mackiewicz on 11/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coordinates.h"

/**
 *  Controller for editing the coordinates presented in CoordinatesViewController.
 */
@interface DetailCoordinatesViewController : UIViewController<UITextFieldDelegate>
@property(weak, nonatomic) Coordinates *coordinates;
@end
