//
//  FlickerViewController.m
//  Task1
//
//  Created by Marcin Mackiewicz on 14/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import "FlickerViewController.h"
#import "FlickerCollectionViewCell.h"

@interface FlickerViewController ()

@end

@implementation FlickerViewController

NSMutableArray *photoArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    photoArray = [[NSMutableArray alloc] init];
    UINib *cellNib = [UINib nibWithNibName:@"FlickerCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"FlickerCollectionViewCell"];

    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=706914e74f4da7d2a5337f9630dc7c19&lat=%@&lon=%@&accuracy=16&per_page=20&page=1&format=json&nojsoncallback=1", self.coordinates.latitude, self.coordinates.longitude]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSArray *photos = [json[@"photos"] objectForKey:@"photo"];
    
    for(NSDictionary* photo in photos) {
        //NSLog(@"%@", photo[@"id"]);
        
        NSURL* photoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=706914e74f4da7d2a5337f9630dc7c19&photo_id=%@&format=json&nojsoncallback=1", photo[@"id"]]];
        
        NSData* photoData = [NSData dataWithContentsOfURL:photoUrl];
        NSError* photoError;
        
        NSDictionary* photoJson = [NSJSONSerialization JSONObjectWithData:photoData options:0 error:&photoError];
        
        NSURL *imageUrl = [NSURL URLWithString:[photoJson[@"sizes"] objectForKey:@"size"][0][@"source"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        [photoArray addObject: image];
    }

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

#pragma mark - Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

/* For now, we won't return any sections */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [photoArray count];

}
/* We don't yet know how we can return cells to the collection view so
 let's return nil for now */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"FlickerCollectionViewCell";
    FlickerCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.image.image = [photoArray objectAtIndex:indexPath.row];
    
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Clicked cell nubmer: %lu", indexPath.row);
}

@end
