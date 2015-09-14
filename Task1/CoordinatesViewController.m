//
//  CoordinatesViewController.m
//  Task1
//
//  Created by Marcin Mackiewicz on 11/09/15.
//  Copyright (c) 2015 Marcin Mackiewicz. All rights reserved.
//

#import "CoordinatesViewController.h"
#import "CoreDataHelper.h"
#import "CoordinatesViewCell.h"
#import "DetailCoordinatesViewController.h"
#import "FlickerViewController.h"

@interface CoordinatesViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

NSMutableArray *coordinatesList;

@implementation CoordinatesViewController

- (id)init {
    self = [super init];
    self.title = @"Coordinates";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    coordinatesList = [NSMutableArray arrayWithArray:[CoreDataHelper fetchDataWithEntityName:@"Coordinates"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(performEditCoordinates:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDismissDetailCoordinatesViewController) name:@"DetailCoordinatesViewControllerDismissed" object:nil];
}

- (void)performEditCoordinates:(id)paramSender {
    if ([self.tableView isEditing]) {
        [super setEditing:NO animated:YES];
        [self.tableView setEditing:NO animated:YES];
    } else {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)didDismissDetailCoordinatesViewController {
    coordinatesList = [[NSMutableArray alloc] initWithArray:[CoreDataHelper fetchDataWithEntityName: @"Coordinates"]];
    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    coordinatesList = [[NSMutableArray alloc] initWithArray:[CoreDataHelper fetchDataWithEntityName: @"Coordinates"]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [coordinatesList count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"CoordinatesViewCell";
    CoordinatesViewCell *cell = (CoordinatesViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CoordinatesViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *content = [NSString stringWithFormat:@"Lat: %@ Lon: %@", [[coordinatesList objectAtIndex:indexPath.row] latitude], [[coordinatesList objectAtIndex:indexPath.row] longitude]];
    
    cell.contentLabel.text = content;
    cell.indicator.tag = indexPath.row;
    [cell.indicator addTarget:self action:@selector(indicatorClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        BOOL result = [CoreDataHelper removeCoreDataObject: [coordinatesList objectAtIndex: indexPath.row]];
        if (result) {
            [coordinatesList removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        } else {
            NSLog(@"Error removing");
        }
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FlickerViewController *flickerViewController = [[FlickerViewController alloc] initWithNibName:@"FlickerViewController" bundle: nil];
    flickerViewController.coordinates = [coordinatesList objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:flickerViewController animated: YES];
}

- (void)indicatorClicked:(UIButton*)sender {
    DetailCoordinatesViewController *detailViewController = [[DetailCoordinatesViewController alloc] initWithNibName:@"DetailCoordinatesViewController" bundle:nil];
    detailViewController.coordinates = [coordinatesList objectAtIndex:sender.tag];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
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
