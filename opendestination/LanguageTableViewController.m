//
//  LanguageTableViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 6/18/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "LanguageTableViewController.h"
#import "Destination.h"
#import "UserModel.h"

@interface LanguageTableViewController ()

@end

@implementation LanguageTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
      NSLog(@" Count %d ", [[[[Destination sharedInstance] languages] allKeys] count]);
    return [[[[Destination sharedInstance] languages] allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    UILabel *counterLbl=[[UILabel alloc] initWithFrame:CGRectMake(40, 15   , 100, 20)];
    [counterLbl setTextAlignment:UITextAlignmentCenter];
        //  counterLbl.backgroundColor=[UIColor clearColor];
         counterLbl.textColor=[UIColor orangeColor];
    
    [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"list-item.png"]]];
    [cell.contentView addSubview:counterLbl];

    NSArray *values = [[[Destination sharedInstance] languages] allKeys];
    // Configure the cell...
    NSDictionary *currentObject= [[[Destination sharedInstance] languages] objectForKey:[values objectAtIndex:indexPath.row]];
    NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[currentObject  objectForKey:@"code"] ] ;
        //    NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[values objectAtIndex:indexPath.row]  objectForKey:@"code"] ] ;

    counterLbl.text= currentLocale.localeIdentifier;
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
    NSArray *values = [[[Destination sharedInstance] languages] allKeys];
    NSDictionary *currentObject= [[[Destination sharedInstance] languages] objectForKey:[values objectAtIndex:indexPath.row]];
    NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[currentObject  objectForKey:@"code"] ] ;
    UserModel *user=[UserModel sharedUser];
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataWasUpdated)
                                                 name:(NSString *)kUserUpdatedNotification
                                               object:user];
    /*  [user postImage:self.photo];
     [user setParam:userModel.birthDate];
     [user setParam:userModel.gender];*/
     [user setLocaleID:[currentObject  objectForKey:@"id"]];
     [user setParam:user.localeID];
   
    
        
        // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
