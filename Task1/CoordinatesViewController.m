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
@property(nonatomic, strong) NSMutableArray *coordinatesList;
@end

@implementation CoordinatesViewController

/**
 *  Initializes the object without parameters
 *
 *  @return instance object.
 */
- (id)init {
    self = [super init];
    self.title = @"Coordinates";
    return self;
}

/**
 *  Invoked when the view loads for the first time.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.coordinatesList = [NSMutableArray arrayWithArray:[CoreDataHelper fetchDataWithEntityName:@"Coordinates"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(performEditCoordinates:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDismissDetailCoordinatesViewController) name:@"DetailCoordinatesViewControllerDismissed" object:nil];
}

/**
 *  Invoked when object receives memory warning.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Invoked when the view appears
 *
 *  @param animated If view is supposed to be animated
 */
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.coordinatesList = [[NSMutableArray alloc] initWithArray:[CoreDataHelper fetchDataWithEntityName: @"Coordinates"]];
    [self.tableView reloadData];
}

/**
 *  Invoked when object receives memoty warning.
 */
- (void)performEditCoordinates:(id)paramSender {
    if ([self.tableView isEditing]) {
        [super setEditing:NO animated:YES];
        [self.tableView setEditing:NO animated:YES];
    } else {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
    }
}

/**
 *  Reloads data when the DetailCoordinatesViewController is dismissed.
 */
- (void)didDismissDetailCoordinatesViewController {
    self.coordinatesList = [[NSMutableArray alloc] initWithArray:[CoreDataHelper fetchDataWithEntityName: @"Coordinates"]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

/**
 *  Sets number of sections in the table view.
 *
 *  @param tableView Table view.
 *
 *  @return Number of sections in table view.
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/**
 *  Sets number of rows in the table view.
 *
 *  @param tableView Table view.
 *  @param section   Table view's section.
 *
 *  @return Number of rows in table view's section.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.coordinatesList count];
}

/**
 *  Sets table view's cell content.
 *
 *  @param tableView Table view;
 *  @param indexPath Index's path.
 *
 *  @return Table's cell.
 */
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"CoordinatesViewCell";
    CoordinatesViewCell *cell = (CoordinatesViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CoordinatesViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *content = [NSString stringWithFormat:@"Lat: %@ Lon: %@", [[self.coordinatesList objectAtIndex:indexPath.row] latitude], [[self.coordinatesList objectAtIndex:indexPath.row] longitude]];
    
    cell.contentLabel.text = content;
    cell.indicator.tag = indexPath.row;
    [cell.indicator addTarget:self action:@selector(indicatorClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

/**
 *  Establishes what happens when we edit a table view's row.
 *
 *  @param tableView    Table view.
 *  @param editingStyle What kind of editing style we are using.
 *  @param indexPath    Index's path.
 */
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        BOOL result = [CoreDataHelper removeCoreDataObject: [self.coordinatesList objectAtIndex: indexPath.row]];
        if (result) {
            [self.coordinatesList removeObjectAtIndex:indexPath.row];
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

/**
 *  Invoked when we select a table view's row.
 *
 *  @param tableView Table view.
 *  @param indexPath Index's path.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FlickerViewController *flickerViewController = [[FlickerViewController alloc] initWithNibName:@"FlickerViewController" bundle: nil];
    flickerViewController.coordinates = [self.coordinatesList objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:flickerViewController animated: YES];
}

/**
 *  Invocked when we click indicator button.
 *
 *  @param sender Indicator button.
 */
- (void)indicatorClicked:(UIButton*)sender {
    DetailCoordinatesViewController *detailViewController = [[DetailCoordinatesViewController alloc] initWithNibName:@"DetailCoordinatesViewController" bundle:nil];
    detailViewController.coordinates = [self.coordinatesList objectAtIndex:sender.tag];
    
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
