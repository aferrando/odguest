    //
    //  MeTableViewController.m
    //  opendestination
    //
    //  Created by Albert Ferrando on 8/14/12.
    //  Copyright (c) 2012 None. All rights reserved.
    //

#import "MeTableViewController.h"
#import "FormKit.h"
#import "UserModel.h"
#import "Destination.h"
#import "SelectSignInViewController.h"
#import "GlobalConstants.h"

@interface MeTableViewController ()

@end

@implementation MeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        valueChanged=FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        //   [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:background]]];
    self.formModel = [FKFormModel formTableModelForTableView:self.tableView
                                        navigationController:self.navigationController];
        //  [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    UserModel *user=[UserModel sharedUser];
    
    [FKFormMapping mappingForClass:[UserModel class] block:^(FKFormMapping *formMapping) {
        [formMapping sectionWithTitle:NSLocalizedString(@"meKey",@"") identifier:@"info"];
        [formMapping mapAttribute:@"realName" title:NSLocalizedString(@"firstNameKey",@"") type:FKFormAttributeMappingTypeText keyboardType:UIKeyboardTypeDefault];
        [formMapping mapAttribute:@"passwordValue" title:NSLocalizedString(@"passwordKey",@"") type:FKFormAttributeMappingTypePassword keyboardType:UIKeyboardTypeDefault];
        [formMapping mapAttribute:@"birthDate" title:NSLocalizedString(@"birthdateKey",@"") type:FKFormAttributeMappingTypeDate dateFormat:@"yyyy-MM-dd"];
            //    [formMapping mapAttribute:@"suitAllAges" title:@"All ages" type:FKFormAttributeMappingTypeBoolean];
            //   [formMapping mapAttribute:@"shortName" title:@"ShortName" type:FKFormAttributeMappingTypeLabel];
            //    [formMapping mapAttribute:@"numberOfActor" title:@"Number of actor" type:FKFormAttributeMappingTypeInteger];
            //   [formMapping mapAttribute:@"content" title:@"Content" type:FKFormAttributeMappingTypeBigText];
        
            //        Doesn't work very good now
            //        [formMapping mapSliderAttribute:@"rate" title:@"Rate" minValue:0 maxValue:10 valueBlock:^NSString *(id value) {
            //            return [NSString stringWithFormat:@"%.1f", [value floatValue]];
            //        }];
        
        [formMapping mapAttribute:@"genderValue"
                            title:NSLocalizedString(@"genderKey",@"")
                     showInPicker:NO
                selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                    *selectedValueIndex = [[user gender] integerValue] ;
                    return [NSArray arrayWithObjects:NSLocalizedString(@"maleKey",@""),
                            NSLocalizedString(@"femaleKey",@""), nil];
                    
                } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                    return value;
                    
                } labelValueBlock:^id(id value, id object) {
                    return value;
                    
                }];
        NSArray *values = [[[Destination sharedInstance] languages] allKeys];
            // Configure the cell...
        NSMutableArray *languages=[[NSMutableArray alloc] init];
        for (int i = 0; i < [values count]; i++) {
            NSDictionary *currentObject= [[[Destination sharedInstance] languages] objectForKey:[values objectAtIndex:i]];
                // if ([(NSNumber *)[currentObject valueForKey:@"id"] intValue]  == row){
            NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[currentObject  objectForKey:@"code"] ] ;
                //    NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[values objectAtIndex:indexPath.row]  objectForKey:@"code"] ] ;
            NSArray *myArray = [[currentLocale  displayNameForKey:NSLocaleIdentifier value:[currentObject  objectForKey:@"code"]] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"("]];
            [languages addObject:[myArray objectAtIndex:0]];
            
                // return currentLocale.localeIdentifier;
                //  }
        }
        /*       return nil;
         NSArray *languages = [NSLocale preferredLanguages];
         for (NSString *language in languages) {
         NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:language] autorelease];
         NSLog(@"language code = %@, display name = %@, in language = %@",
         language,
         [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:language],
         [locale displayNameForKey:NSLocaleIdentifier value:language]);
         }
         */
        [formMapping mapAttribute:@"localeIDValue"
                            title:@"Languages"
                     showInPicker:NO
                selectValuesBlock:^NSArray *(id value, id object, NSInteger *selectedValueIndex){
                    *selectedValueIndex = [user.localeID integerValue];
                    return languages;
                    
                } valueFromSelectBlock:^id(id value, id object, NSInteger selectedValueIndex) {
                    [user setLocaleID:[NSString stringWithFormat:@"%d",selectedValueIndex]];
                    return value;
                    
                } labelValueBlock:^id(id value, id object) {
                    return value;
                    
                }];
        
        /*      [formMapping sectionWithTitle:@"Custom cells" identifier:@"customCells"];
         
         [formMapping mapCustomCell:[UITableViewCell class]
         identifier:@"custom"
         rowHeight:70
         willDisplayCellBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
         cell.textLabel.text = @"I am a custom cell !";
         
         }     didSelectBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
         NSLog(@"You pressed me");
         
         }];
         
         [formMapping mapCustomCell:[UITableViewCell class]
         identifier:@"custom2"
         willDisplayCellBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
         cell.textLabel.text = @"I am a custom cell too !";
         
         }     didSelectBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
         NSLog(@"You pressed me");
         
         }];
         */
            //   [formMapping sectionWithTitle:@"Buttons" identifier:@"saveButton"];
        
        [formMapping buttonSave:NSLocalizedString(@"saveKey", @"") handler:^{
            NSLog(@"save pressed");
            NSLog(@"%@", self.user.realName);
            [self.formModel save];
            [user save];
            valueChanged=FALSE;
        }];
        [formMapping sectionWithTitle:NSLocalizedString(@"signOutKey",@"") identifier:@"signout"];
        
        [formMapping mapCustomCell:[UITableViewCell class]
                        identifier:@"custom"
                         rowHeight:40
              willDisplayCellBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
                  cell.textLabel.text = NSLocalizedString(@"signOutKey", @"");
                  
              }     didSelectBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
                                       [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"SignOutTitleKey",@"Are you sure you'd like to sign out?") delegate:self cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"signOutKey",@"Sign Out"), nil] showFromTabBar:self.view];
                      
                  
              }];
        
        [self.formModel registerMapping:formMapping];
    }];
    
    [self.formModel setDidChangeValueWithBlock:^(id object, id value, NSString *keyPath) {
            //     [self.formModel
        NSLog(@"did change model value");
        valueChanged=TRUE;
    }];
    
    [self.formModel loadFieldsWithObject:user];
    
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
    
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //sign out confirmed
        [[UserModel sharedUser] signOut];
        
        SelectSignInViewController *loginVC = [[SelectSignInViewController alloc] initWithNibName:@"SelectSignInViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:loginVC];
        [navigationController.navigationBar setTintColor:kMainColor];
            //  loginVC.delegate = self;
            // LoginViewController * vc = [[LoginViewController alloc] init];
            //[vc addCloseWindow];
        [self.navigationController presentModalViewController:navigationController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void) saveSettings{
    [self.formModel save];
    [[UserModel sharedUser] save];
}
-(void) clickBack {
    alert = [BlockAlertView alertWithTitle:NSLocalizedString(@"",@"Alert") message:NSLocalizedString(@"saveMsgKey",@"Must be registered to set your deals and add points to your profile")];
    
    [alert addButtonWithTitle:NSLocalizedString(@"saveKey",@"Sign In") block:^{
            // Do something or nothing.... This block can even be nil!
        [self saveSettings];
        [self.navigationController popViewControllerAnimated:TRUE];
        
    }];
    [alert setCancelButtonWithTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel") block:^{
            // Do something or nothing.... This block can even be nil!
        [self.navigationController popViewControllerAnimated:TRUE];
        
    }];
    [alert show];
    
}
-(void) viewWillDisappear:(BOOL)animated   {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
            // back button was pressed.  We know this is true because self is no longer
            // in the navigation stack.
        if (valueChanged)
            [self clickBack];
    }
    [super viewWillDisappear:animated];
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
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
        // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
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
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
}

@end
