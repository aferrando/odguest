//
//  CustomViewController.h
//  opendestination
//
//  Created by David Hoyos on 04/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"
#import "UserModel.h"
#import "Destination.h"
    //#import "DAReloadActivityButton.h"
    //#import "AwesomeMenu.h"
    //#import "MGTileMenuController.h"
#import "AnonymousBarViewController.h"
#import "FGalleryViewController.h"
@class CategoryModel;

@interface CustomContentViewController : UIViewController <UIScrollViewDelegate,FGalleryViewControllerDelegate>
    //, MGTileMenuDelegate, AwesomeMenuDelegate> 
{
IBOutlet   UILabel * titleLabel;
  UIImageView * headerBackgroundImage;
  UIScrollView * customView;
IBOutlet UIBarButtonItem   * backButton;
IBOutlet UIButton *notificationsButton;
    IBOutlet UIPageControl *pageControl;
        //  ContentPageTransitionType transition;
    CategoryModel * _category;
        //   DAReloadActivityButton *viewButton;
  NSMutableArray * _categoriesButtons;
  NSMutableArray * _categoriesBadgets;
  NSMutableArray * _categoriesLabels;
    CustomBadge *customBadge;
    BOOL pageControlUsed;
        //   AwesomeMenu *_menu;
    UserModel * _userModel;
    Destination * _destination;
    UIProgressView *progressView;
    UIButton * menuButton;
    NSArray *networkCaptions;
    NSArray *networkImages;

    __unsafe_unretained IBOutlet UIToolbar *topToolBar;
    __unsafe_unretained IBOutlet UIButton *registerGuest;
}
@property ( nonatomic ) IBOutlet UILabel * titleLabel;
@property ( nonatomic ) IBOutlet UIView * headerBackgroundImage;
@property ( nonatomic ) IBOutlet UIBarButtonItem * backButton;
@property ( nonatomic ) IBOutlet UIButton * notificationsButton;
@property (strong, nonatomic) AnonymousBarViewController *anonymousBar;
    //@property ( nonatomic ) IBOutlet DAReloadActivityButton * viewButton;
@property ( nonatomic ) UIPageControl *pageControl;
@property ( nonatomic ) UIScrollView * customView;
@property ( nonatomic ) CategoryModel * category;
@property ( nonatomic ) CustomBadge *customBadge;
@property ( nonatomic ) UserModel * userModel; 
@property ( nonatomic ) Destination * destination; 
@property ( nonatomic ) UIProgressView * progressView; 
    //@property (strong, nonatomic) MGTileMenuController *tileController;
@property (strong, nonatomic) UIButton *menuButton;

- (void) setTitleLabelForHeader;
- (IBAction) goBack;
- (IBAction) buttonPressed:(id)sender;
- (IBAction)notificationButtonPressed:(id)sender;
- (void) reload;
- (void) showCategories;
@end
