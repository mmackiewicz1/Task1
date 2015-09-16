//
//  CoordinatesViewCell.h
//  Task1
//
//  Created by Marcin Mackiewicz on 11/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Controller for table view cells in CoordinatesViewController.
 */
@interface CoordinatesViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *indicator;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end
