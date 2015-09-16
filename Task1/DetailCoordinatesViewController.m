//
//  DetailCoordinatesViewController.m
//  Task1
//
//  Created by Marcin Mackiewicz on 11/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import "DetailCoordinatesViewController.h"
#import "CoreDataHelper.h"

@interface DetailCoordinatesViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputLatitude;
@property (weak, nonatomic) IBOutlet UITextField *inputLongitude;

- (IBAction)submitCoordinates:(id)sender;
@end

/**
 *  Invoked when the view loads for the first time.
 */
@implementation DetailCoordinatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Edit coordinates";
    self.inputLatitude.delegate = self;
    self.inputLongitude.delegate = self;
    self.inputLatitude.text = [NSString stringWithFormat:@"%@", self.coordinates.latitude];
    self.inputLongitude.text = [NSString stringWithFormat:@"%@", self.coordinates.longitude];
}

/**
 *  Invoked when object receives memory warning.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Hides the keyboard upon clicking "Return".
 *
 *  @param textField Text field present in the view.
 *
 *  @return If text field should remain.
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 *  Invoked when we want to submit new coordinates data.
 *
 *  @param sender Button sender.
 */
- (IBAction)submitCoordinates:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    self.coordinates.longitude = [formatter numberFromString: self.inputLongitude.text];
    self.coordinates.latitude = [formatter numberFromString: self.inputLatitude.text];
    BOOL result = [CoreDataHelper update];
    if (result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailCoordinatesViewControllerDismissed" object:nil userInfo:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
