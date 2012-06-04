//
//  ConnectTableViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 12/1/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import "ConnectTableViewController.h"
#import "ConnectViewController.h"
#import "CustomNavigationBar.h"

@implementation ConnectTableViewController
@synthesize categories;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*  make sure that we set the image to be centered  */ 
    /*  you will ahve to make minor adjustments depending on the dimensions of your image.  */
   // self.navigationItem.hidesBackButton = YES; 
     
 /*   UIImage *image = [UIImage imageNamed:@"tabbarbackground.png"];
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    imgView.image = image;
    [tempView addSubview:imgView];
  //  [navBar clearBackgroundImage];
    [navBar addSubview:tempView];
    [tempView release];*/
    [self setTitle:NSLocalizedString(@"selectActivityKey", @"Select Activity?")];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeWindow)];      
    self.navigationItem.leftBarButtonItem = sendButton;
    categories = [[NSMutableArray alloc] initWithCapacity:0];
    CategoryModel *category=[[CategoryModel alloc] init];
    category.categoryID =12;
    category.name=NSLocalizedString(@"buddiesKey",@"Buddies ");
    category.description=NSLocalizedString(@"buddiesDescKey",@"Buddies description ");
    [categories addObject:category];
    category=[[CategoryModel alloc] init];
    category.categoryID =23;
    category.name=NSLocalizedString(@"carsharingKey",@"Car sharing ");
    category.description=NSLocalizedString(@"carsharingDescKey",@"Buddies description ");
    [categories addObject:category];
    category=[[CategoryModel alloc] init];
    category.categoryID =21;
    category.name=NSLocalizedString(@"partyKey",@"Buddies ");
    category.description=NSLocalizedString(@"partyDescKey",@"Buddies description ");
    [categories addObject:category];
    category=[[CategoryModel alloc] init];
    category.categoryID =6;
    category.name=NSLocalizedString(@"othersKey",@"Buddies ");
    category.description=NSLocalizedString(@"othersDescKey",@"Buddies description ");
    [categories addObject:category];
    
    
 //   [navBar setTitleTextAttributes:];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
 /*   
    // Set the title view to the Instagram logo
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:12.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    label.text = NSLocalizedString(@"selectActivityKey", @"Select Activity?");

    self.navigationItem.titleView = label;
 /*  
    // Get our custom nav bar
    CustomNavigationBar* customNavigationBar = (CustomNavigationBar*) self.navigationController.navigationBar;
    
    // Set the nav bar's background
    [customNavigationBar setBackgroundWith:[UIImage imageNamed:@"nav_bg.png"]];
    // Create a custom back button
    UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"navigationBarBackButton.png"] highlight:nil leftCapWidth:14.0];
    backButton.titleLabel.textColor = [UIColor colorWithRed:254.0/255.0 green:239.0/255.0 blue:218.0/225.0 alpha:1];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
*/
    
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
- (void) closeWindow {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textColor=[UIColor orangeColor];
    CategoryModel *categorySelected= (CategoryModel *)[categories objectAtIndex:indexPath.row];
    cell.textLabel.text=categorySelected.name;
    cell.detailTextLabel.textColor=[UIColor whiteColor];
    cell.detailTextLabel.numberOfLines = 4;
    cell.detailTextLabel.text=categorySelected.description;
/*    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=NSLocalizedString(@"BuddiesKey",@"Buddies");
            cell.detailTextLabel.text=NSLocalizedString(@"BuddiesKey",@"Buddies");
            cell.imageView.image=[UIImage imageNamed:@"buddies_icon.png"];
            break;
        case 1:
            cell.textLabel.text=NSLocalizedString(@"CarsharingKey",@"Buddies");
            cell.detailTextLabel.text=NSLocalizedString(@"CarsharingKey",@"Buddies");
            cell.imageView.image=[UIImage imageNamed:@"carsharing_icon.png"];
            break;
        case 2:
            cell.textLabel.text=NSLocalizedString(@"PartyKey",@"Buddies");
            cell.detailTextLabel.text=NSLocalizedString(@"PartyKey",@"Buddies");
            cell.imageView.image=[UIImage imageNamed:@"nightclub_icon.png"];
            
            break;
        case 3:
            cell.textLabel.text=NSLocalizedString(@"OthersKey",@"Buddies");
            cell.detailTextLabel.text=NSLocalizedString(@"OthersKey",@"Buddies");
            cell.imageView.image=[UIImage imageNamed:@"miscelaneous_icon.png"];
            
            break;
            
        default:
            break;
    }*/
    // Configure the cell...
    
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
    // Navigation logic may go here. Create and push another view controller.
    
     ConnectViewController *detailViewController = [[ConnectViewController alloc] initWithNibName:@"ConnectViewController" bundle:nil];
    [detailViewController addBackWindow];
    [detailViewController setCategory:[categories objectAtIndex:indexPath.row]];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     
}

@end
