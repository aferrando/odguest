//
//  SendPasswordViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 8/21/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockAlertView.h"
@interface SendPasswordViewController : UIViewController {
    BlockAlertView *alert;

}
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIButton *sendpassword;
@property (strong, nonatomic) BlockAlertView *alert;

- (IBAction)sendPassword:(id)sender;
@end
