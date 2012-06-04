//
//  MyInterestsTableViewController.m
//  opendestination
//
//  Created by David Hoyos on 04/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import "MyInterestsTableViewController.h"
#import "CustomTableViewCell.h"
#import "TagsModel.h"



@implementation MyInterestsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
      _searchBar = nil;
      _tags = [[TagsModel alloc] init];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kTagsUpdatedNotification object:_tags];
    }
    return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  [_tags reload];
  [self.tableView setSeparatorColor:[UIColor blackColor]];
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.tableView setBackgroundColor:[UIColor blackColor]];
  // self.clearsSelectionOnViewWillAppear = NO;
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma mark Table view data delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 62.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section 
{
  return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  _searchBar = [[UISearchBar alloc] initWithFrame:self.tableView.tableHeaderView.frame];
  [_searchBar setDelegate:self];
  //[searchBar setTintColor:
  //[UIColor colorWithRed:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>];
  [_searchBar setBarStyle:UIBarStyleBlackTranslucent];
  return _searchBar;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";	
	CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  
  //if ([self.categorys count] !=0) {
  //Category * c = [self.categories objectAtIndex:[indexPath row]];
  
	if (cell == nil) {		
		cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIView * content = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 62)];
    [content setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grey_cell_empty.png"]]];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 6.0, 50.0, 50.0)];
    [[cell subviewsDict] setObject:imageView forKey:@"imageView"];
    [content addSubview:imageView];
    
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 16.0, 200, 30)];
    textLabel.font = [UIFont boldSystemFontOfSize:18];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines = 1;
    [[cell subviewsDict] setObject:textLabel forKey:@"textLabel"];
    [content addSubview:textLabel];
    
    [cell.contentView addSubview:content];
	}
  NSMutableDictionary * dict = cell.subviewsDict;
  [[dict objectForKey:@"textLabel"] setText:[NSString stringWithFormat:@"%d Interest", indexPath.row]];
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
  if ( [cell accessoryType] == UITableViewCellAccessoryNone ) {
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    //TODO: Modify filters
  } else {
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    //TODO: Modify filters
  }
}

#pragma mark - public methods;

- (void) refresh
{
  [self.tableView reloadData];
}

# pragma mark - searchBar delegate

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
  return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
  [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
  return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
  [searchBar setShowsCancelButton:NO animated:YES];
}



@end