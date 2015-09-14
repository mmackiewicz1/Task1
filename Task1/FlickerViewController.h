//
//  FlickerViewController.h
//  Task1
//
//  Created by Marcin Mackiewicz on 14/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coordinates.h"

@interface FlickerViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) Coordinates *coordinates;
@end
