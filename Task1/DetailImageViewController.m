//
//  DetailImageViewController.m
//  Task1
//
//  Created by Marcin Mackiewicz on 14/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import "DetailImageViewController.h"

@interface DetailImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@end

@implementation DetailImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            [self.spinner setCenter:CGPointMake(screenRect.size.width/2, screenRect.size.height/2)];
            [self.view addSubview:self.spinner];
            [self.spinner startAnimating];
        });
        
        NSURL* photoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=706914e74f4da7d2a5337f9630dc7c19&photo_id=%@&format=json&nojsoncallback=1", self.imageId]];
        
        NSData* photoData = [NSData dataWithContentsOfURL:photoUrl];
        NSError* photoError;
        NSDictionary* photoJson = [NSJSONSerialization JSONObjectWithData:photoData options:0 error:&photoError];
        
        NSURL *imageUrl = [NSURL URLWithString:[photoJson[@"sizes"] objectForKey:@"size"][5][@"source"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            self.imageView.image = image;
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
