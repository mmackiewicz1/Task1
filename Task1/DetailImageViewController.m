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
@end

@implementation DetailImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL* photoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=706914e74f4da7d2a5337f9630dc7c19&photo_id=%@&format=json&nojsoncallback=1", self.imageId]];
    
    NSData* photoData = [NSData dataWithContentsOfURL:photoUrl];
    NSError* photoError;
    
    NSDictionary* photoJson = [NSJSONSerialization JSONObjectWithData:photoData options:0 error:&photoError];
    
    NSURL *imageUrl = [NSURL URLWithString:[photoJson[@"sizes"] objectForKey:@"size"][5][@"source"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    self.imageView.image = image;
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
