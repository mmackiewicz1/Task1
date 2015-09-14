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

@property (nonatomic, strong) NSInvocationOperation *firstOperation;
@property (nonatomic, strong) NSInvocationOperation *secondOperation;
@property (nonatomic, strong) NSInvocationOperation *thirdOperation;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
- (IBAction)startOperations:(id)sender;
@end

@implementation ListViewController

- (id)init {
    self = [super init];
    self.title = @"List";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.squareOne.backgroundColor = [UIColor redColor];
    self.squareTwo.backgroundColor = [UIColor redColor];
    self.squareThree.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) firstOperationEntry:(id)paramObject{
    NSLog(@"First operation");
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        self.squareOne.backgroundColor = [UIColor yellowColor];
    }];
    for (int i = 0; i < 10000; i++) {
        NSLog(@"First loop: %d", i);
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        self.squareOne.backgroundColor = [UIColor greenColor];
    }];
}

- (void) secondOperationEntry:(id)paramObject{
    NSLog(@"Second operation");
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        self.squareTwo.backgroundColor = [UIColor yellowColor];
    }];
    for (int i = 0; i < 10000; i++) {
        NSLog(@"Second loop: %d", i);
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        self.squareTwo.backgroundColor = [UIColor greenColor];
    }];
}

- (void) thirdOperationEntry:(id)paramObject{
    NSLog(@"Third operation");
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        self.squareThree.backgroundColor = [UIColor yellowColor];
    }];
    
    for (int i = 0; i < 10000; i++) {
        NSLog(@"Third loop: %d", i);
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        self.squareThree.backgroundColor = [UIColor greenColor];
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

- (IBAction)startOperations:(id)sender {
    NSLog(@"Started.");
    
    self.firstOperation = [[NSInvocationOperation alloc]
                           initWithTarget:self
                           selector:@selector(firstOperationEntry:) object:nil];
    
    self.secondOperation = [[NSInvocationOperation alloc]
                            initWithTarget:self
                            selector:@selector(secondOperationEntry:) object:nil];
    
    self.thirdOperation = [[NSInvocationOperation alloc]
                            initWithTarget:self
                            selector:@selector(thirdOperationEntry:) object:nil];
    
    [self.thirdOperation addDependency:self.secondOperation];
    [self.secondOperation addDependency:self.firstOperation];
    
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self.operationQueue addOperation:self.firstOperation];
    [self.operationQueue addOperation:self.secondOperation];
    [self.operationQueue addOperation:self.thirdOperation];
}

@end
