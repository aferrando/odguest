//
//  EmptyHeaderViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 8/20/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmptyHeaderViewController.h"
@interface EmptyHeaderViewController : UIViewController {
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIButton *signinButton;
- (IBAction)signinButtonPressed:(id)sender;
@end
