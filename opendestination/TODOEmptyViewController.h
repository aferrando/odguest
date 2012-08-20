//
//  TODOEmptyViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 8/19/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TODOEmptyViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *signinButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
- (IBAction)signinButtonPressed:(id)sender;

@end
