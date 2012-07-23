//
//  AnonymousBarViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 7/20/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnonymousBarViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
- (IBAction)signInBtnPressed:(id)sender;

@end
