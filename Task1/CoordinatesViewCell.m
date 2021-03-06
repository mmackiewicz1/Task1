//
//  CoordinatesViewCell.m
//  Task1
//
//  Created by Marcin Mackiewicz on 11/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import "CoordinatesViewCell.h"

@implementation CoordinatesViewCell

/**
 *  Invoked when awoken from Nib.
 */
- (void)awakeFromNib {
    [self.indicator addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
}

/**
 *  Highlights an Indicator button.
 *
 *  @param sender Indicator button.
 */
- (void)buttonHighlight:(UIButton*)sender {
    [sender setHighlighted:YES];
}

/**
 *  Configures the view for the selected state.
 *
 *  @param selected If it is selected.
 *  @param animated If it is animated.
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
