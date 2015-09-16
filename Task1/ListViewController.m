//
//  ListViewController.m
//  Task1
//
//  Created by Marcin Mackiewicz on 11/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()
@property (weak, nonatomic) IBOutlet UILabel *squareOne;
@property (weak, nonatomic) IBOutlet UILabel *squareTwo;
@property (weak, nonatomic) IBOutlet UILabel *squareThree;
@property (strong, nonatomic) NSInvocationOperation *firstOperation;
@property (strong, nonatomic) NSInvocationOperation *secondOperation;
@property (strong, nonatomic) NSInvocationOperation *thirdOperation;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIProgressView *taskOneProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *taskTwoProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *taskThreeProgressView;

- (IBAction)startOperations:(id)sender;
- (IBAction)resetOperations:(id)sender;
@end

@implementation ListViewController

/**
 *  Initializes the object without parameters
 *
 *  @return instance object.
 */
- (id)init {
    self = [super init];
    self.title = @"List";
    
    return self;
}

/**
 *  Invoked when the view loads for the first time.
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    self.squareOne.backgroundColor = [UIColor redColor];
    self.squareTwo.backgroundColor = [UIColor redColor];
    self.squareThree.backgroundColor = [UIColor redColor];

    self.taskOneProgressView.progress = 0.0;
    self.taskTwoProgressView.progress = 0.0;
    self.taskThreeProgressView.progress = 0.0;
}

/**
 *  Invoked when object receives memory warning.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  First operation.
 *
 *  @param paramObject Parameter Object.
 */
- (void) firstOperationEntry:(id)paramObject{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        [self.startButton setEnabled:NO];
        [self.resetButton setEnabled:NO];
        NSLog(@"First operation");
        self.squareOne.backgroundColor = [UIColor yellowColor];
    }];
    
    for (int i = 1; i <= 10000; i++) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            self.taskOneProgressView.progress = i/10000.0;
        }];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        self.squareOne.backgroundColor = [UIColor greenColor];
    }];
}

/**
 *  Second operation.
 *
 *  @param paramObject Parameter Object.
 */
- (void) secondOperationEntry:(id)paramObject{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        NSLog(@"Second operation");
        self.squareTwo.backgroundColor = [UIColor yellowColor];
    }];
    
    for (int i = 1; i <= 10000; i++) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            self.taskTwoProgressView.progress = i/10000.0;
        }];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        self.squareTwo.backgroundColor = [UIColor greenColor];
    }];
}

/**
 *  Third operation.
 *
 *  @param paramObject Parameter Object.
 */
- (void) thirdOperationEntry:(id)paramObject{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        NSLog(@"Third operation");
        self.squareThree.backgroundColor = [UIColor yellowColor];
    }];
    
    for (int i = 1; i <= 10000; i++) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            self.taskThreeProgressView.progress = i/10000.0;
        }];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        self.squareThree.backgroundColor = [UIColor greenColor];
        [self.startButton setEnabled:YES];
        [self.resetButton setEnabled:YES];
    }];
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
 *  Invoked when we click the Start button.
 *
 *  @param sender Sender.
 */
- (IBAction)startOperations:(id)sender {
    self.firstOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(firstOperationEntry:) object:nil];
    self.secondOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(secondOperationEntry:) object:nil];
    self.thirdOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(thirdOperationEntry:) object:nil];
    
    [self.thirdOperation addDependency:self.secondOperation];
    [self.secondOperation addDependency:self.firstOperation];
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self.operationQueue addOperation:self.firstOperation];
    [self.operationQueue addOperation:self.secondOperation];
    [self.operationQueue addOperation:self.thirdOperation];
}

/**
 *  Invoked when we click the Reset button.
 *
 *  @param sender Sender.
 */
- (IBAction)resetOperations:(id)sender {
    self.squareOne.backgroundColor = [UIColor redColor];
    self.squareTwo.backgroundColor = [UIColor redColor];
    self.squareThree.backgroundColor = [UIColor redColor];
    
    self.taskOneProgressView.progress = 0.0;
    self.taskTwoProgressView.progress = 0.0;
    self.taskThreeProgressView.progress = 0.0;
}

@end
