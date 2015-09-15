//
//  FlickerViewController.m
//  Task1
//
//  Created by Marcin Mackiewicz on 14/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import "FlickerViewController.h"
#import "FlickerCollectionViewCell.h"
#import "DetailImageViewController.h"

@interface FlickerViewController ()
@property(nonatomic, strong) NSMutableArray *photoArray;
@property(nonatomic, strong) NSMutableArray *idArray;
@property(nonatomic, strong) UIActivityIndicatorView *spinner;
@property(nonatomic) NSUInteger page;
@property(nonatomic) BOOL downloading;
@end

@implementation FlickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.photoArray = [[NSMutableArray alloc] init];
    self.idArray = [[NSMutableArray alloc] init];
    UINib *cellNib = [UINib nibWithNibName:@"FlickerCollectionViewCell" bundle:nil];
    self.page = 1;
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"FlickerCollectionViewCell"];
    [self downloadImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadImages {
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.downloading = YES;
            if (self.spinner == nil) {
                self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                [self.spinner setCenter:CGPointMake(screenRect.size.width/2, screenRect.size.height/2)];
                [self.view addSubview:self.spinner];
            }
            [self.spinner startAnimating];
        });
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=706914e74f4da7d2a5337f9630dc7c19&lat=%@&lon=%@&accuracy=16&per_page=30&page=%lu&format=json&nojsoncallback=1", self.coordinates.latitude, self.coordinates.longitude, self.page]];
        NSData* data = [NSData dataWithContentsOfURL:url];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *photos = [json[@"photos"] objectForKey:@"photo"];
        
        for (NSDictionary* photo in photos) {
            NSURL* photoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=706914e74f4da7d2a5337f9630dc7c19&photo_id=%@&format=json&nojsoncallback=1", photo[@"id"]]];   
            NSData* photoData = [NSData dataWithContentsOfURL:photoUrl];
            NSError* photoError;
            NSDictionary* photoJson = [NSJSONSerialization JSONObjectWithData:photoData options:0 error:&photoError];
            
            NSURL *imageUrl = [NSURL URLWithString:[photoJson[@"sizes"] objectForKey:@"size"][0][@"source"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            [self.photoArray addObject: image];
            [self.idArray addObject: photo[@"id"]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];
            self.downloading = NO;
        });
    });
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
    return [self.photoArray count];

}
/* We don't yet know how we can return cells to the collection view so
 let's return nil for now */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"FlickerCollectionViewCell";
    FlickerCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.image.image = [self.photoArray objectAtIndex:indexPath.row];
    
    return cell;

}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView{
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset + scrollViewHeight == scrollContentSizeHeight + 49 && self.downloading == NO) {
        self.page += 1;
        [self downloadImages];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailImageViewController *detailImageViewController = [[DetailImageViewController alloc] initWithNibName:@"DetailImageViewController" bundle:nil];
    detailImageViewController.imageId = [self.idArray objectAtIndex: indexPath.row];
    
    [self.navigationController pushViewController:detailImageViewController animated:YES];
}

@end
