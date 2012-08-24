//
//  CategoriesTableViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 8/5/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "CategoryModel.h"
#import "Destination.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "PistePlanViewController.h"
#import "OpportunitiesListViewController.h"
#import "GlobalConstants.h"

#define kCellHeigth 100.0

@interface CategoriesTableViewController ()

@end

@implementation CategoriesTableViewController
@synthesize userModel=_userModel;
@synthesize category=_category;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _category = nil;
  }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
        //  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   self.userModel=[UserModel sharedUser];
        // [self setCategory:[[CategoryModel alloc] initWithId:0]];
        //  [self.category reload];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:(NSString *)kCategoryUpdatedNotification object:_category];
    [self.category reload];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadUser)
                                                 name:kUserUpdatedNotification
                                               object:self.userModel];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                              target:self
                                              action:@selector(update)];

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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeigth;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"Number of rows:%d",self.category.sons.count );
    return self.category.sons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //  [cell removeFromSuperview];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellAccessoryDisclosureIndicator;
            // Configure the cell...
        CategoryModel *currentCategory=(CategoryModel *)[self.category.sons objectAtIndex:indexPath.row];
        cell.textLabel.text=currentCategory.name;
        UIView * content = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, kCellHeigth)];
        
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, kCellHeigth-2)];
        [content addSubview:imageView];
         imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView setImageWithURL:[NSURL URLWithString:currentCategory.imageURL] placeholderImage:[UIImage imageNamed:@"samplebackground.jpg"]]; 
        //  UIImage *temp_image = [self imageByCropping:imageView.image toRect:CGRectMake(0.0, 90, 320, kCellHeigth)];
        //[imageView setImage:temp_image];
        if (currentCategory.numOpportunities == 0) {
            UIImageView * coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, kCellHeigth)];
            [coverView setImage:[UIImage imageNamed:@"list-item.png"]];
            [coverView setAlpha:0.9];
            [content addSubview:coverView];
        } else {
            UIImageView * coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, kCellHeigth)];
            [coverView setImage:[UIImage imageNamed:@"list-item.png"]];
                // [coverView setBackgroundColor:[UIColor blackColor]];
            [coverView setAlpha:0.6];
            [content addSubview:coverView];
            
        }
        UIImageView * iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 50, 50)];
        [iconView setImageWithURL:[NSURL URLWithString:currentCategory.iconURL] placeholderImage:[UIImage imageNamed:@"samplebackground.jpg"]]; 
        [content addSubview:iconView];
        CustomBadge *customBadge2 = [CustomBadge customBadgeWithString:[[NSString alloc]initWithFormat:@"%d", currentCategory.numOpportunities]
                                                   withStringColor:kBadgeStringColor
                                                    withInsetColor:kMainColor 
                                                    withBadgeFrame:YES 
                                               withBadgeFrameColor:kBadgeFrameColor
                                                         withScale:1.1
                                                       withShining:NO];
        [customBadge2 setFrame:CGRectMake(250, kCellHeigth/2-14, customBadge2.frame.size.width, customBadge2.frame.size.height)];
    [content addSubview:customBadge2];
        UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, kCellHeigth/2-25, 192, 50)];
        textLabel.font = [UIFont boldSystemFontOfSize:19];
        textLabel.textColor = [UIColor whiteColor];
        [textLabel setShadowColor:[UIColor blackColor]];
        [textLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
        [textLabel setMinimumFontSize:10.0];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.numberOfLines = 2;
        textLabel.text=currentCategory.name;
        [content addSubview:textLabel];
        [cell.contentView addSubview:content];
    
     
     return cell;
}
-(UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{;
    NSLog(@"imagetocrop size: (w: %0.2f, h: %0.2f)",imageToCrop.size.width,imageToCrop.size.height);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320.0, imageToCrop.size.height), NO, 0.0);
    [imageToCrop drawInRect:CGRectMake(0, 0, 320, imageToCrop.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], rect);
    NSLog(@"imagetocrop size: (w: %0.2f, h: %0.2f)",newImage.size.width,newImage.size.height);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    NSLog(@"imagetocrop size: (w: %0.2f, h: %0.2f)",cropped.size.width,cropped.size.height);
    
    return cropped;
}


#pragma mark -
- (void) setTitleLabelForHeader {
    
    if ( ( self.title ) && !( [self.title isEqualToString:@""] ) )
        {
        /*   self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0,0.0,230, self.headerBackgroundImage.frame.size.height)];
         [self.titleLabel setBackgroundColor:[UIColor clearColor]];
         [self.titleLabel setText:self.title];
         [self.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
         [self.titleLabel setMinimumFontSize:12.0];
         [self.titleLabel setTextColor:[UIColor whiteColor]];
         [self.titleLabel setTextAlignment:UITextAlignmentCenter];
         [self.headerBackgroundImage addSubview:self.titleLabel];
         [self.titleLabel release];*/
            // [self.navigationBar titleLabel setText:self.title]; 
            //[self.navigationItem setTitle:((RootViewController *)[self.view.window rootViewController] getDestination .];
        } else {
            [self.navigationItem setTitle:self.category.name];
        }
    if (self.category.categoryID == 0) { 
            //  [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 300, 30)]; 
        UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(10, 0, 160, 30)];
        
        title.text = [[Destination sharedInstance] destinationName];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:20.0]];
        
        [title setBackgroundColor:[UIColor clearColor]];
        UIImageView *myImageView = [[UIImageView alloc] init];
        [myImageView setImageWithURL:[NSURL URLWithString:[[Destination sharedInstance] destinationImage]] placeholderImage:[UIImage imageNamed:@"deal_photodefault.png"]];
        
        myImageView.frame = CGRectMake(0, 0, 130, 30); 
        myImageView.layer.cornerRadius = 5.0;
        myImageView.layer.masksToBounds = YES;
        myImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        myImageView.layer.borderWidth = 0.1;
        
        [myView addSubview:title];
        [myView setBackgroundColor:[UIColor  clearColor]];
            //   [myView addSubview:myImageView];
        self.navigationItem.titleView = myView;
        
            //       [self.navigationItem setTitle:[[Destination sharedInstance] destinationName]];
    }
}

- (void) update {
    [self setTitleLabelForHeader];
    [self.category reload];
    
        // [self reload];
}

- (void) reload{
    if (![self.userModel isGuest]){
        
        UITabBarItem *mapTabBarItem= [[((UITabBarController *)[self.view.window rootViewController]).tabBar items] objectAtIndex:1]; // I want to desable the second tab for example (index 1)
        UITabBarItem *mapTabBarItem2= [[((UITabBarController *)[self.view.window rootViewController]).tabBar items] objectAtIndex:2]; // I want to desable  
        [mapTabBarItem setEnabled:YES];
        [mapTabBarItem2 setEnabled:YES];
        [mapTabBarItem2 setTitle:[self.userModel realName]];
        ((UITabBarController *)[self.view.window rootViewController]).hidesBottomBarWhenPushed=TRUE;
    }
    [self.tableView reloadData];  
}
-(void) reloadUser{
    
}
#pragma mark -
- (void) setCategory:(CategoryModel *)category {
    /* _category=category;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:(NSString *)kCategoryUpdatedNotification object:_category];*/
        //  [[NSNotificationCenter defaultCenter] removeObserver:self name:kCategoryUpdatedNotification object:_category];
    _category = nil;
    if (category) {
        _category = category;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:(NSString *)kCategoryUpdatedNotification object:_category];
        [self.category reload];
    }
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    CategoryModel * cat = [self.category.sons objectAtIndex:indexPath.row];
        //Categories that require specific Controllers such as: PistePlan, Meteo and Snow conditions.
#warning AddCode for the PistePlan
    if ([cat.name isEqualToString:@"PistePlan"])
        {
        PistePlanViewController * piste = [[PistePlanViewController alloc] initWithNibName:@"PistePlanViewController" bundle:nil];
            // [detail setCategory:cat];
        piste.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:piste animated:YES];
        
        }
        //  UIViewController * vc = nil;
    if ( ( cat.numOpportunities > 0) && ([cat.sons count] > 0) ) {
        CategoriesTableViewController * detail = [[CategoriesTableViewController alloc] init];
        [detail setCategory:cat];
        [self.parentViewController.navigationController pushViewController:detail animated:YES];
    } else if (cat.numOpportunities > 0 ) {
        OpportunitiesListViewController * detail = [[OpportunitiesListViewController alloc] init];
        [detail setCategory:cat];
        detail.hidesBottomBarWhenPushed = YES;  
        
        [self.parentViewController.navigationController pushViewController:detail animated:YES];
    }
    
}

@end
