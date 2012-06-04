//
//  NotificationsTableViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 12/12/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsTableViewController : UITableViewController{
    UILabel *noItemLabel;

}
@property ( nonatomic) IBOutlet UISegmentedControl *typeSegmentedCtrl;
@property ( nonatomic)  UILabel *noItemLabel;
-(void) addCloseWindow;
- (IBAction)changeType:(id)sender;

@end
