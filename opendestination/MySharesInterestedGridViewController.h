//
//  MySharesInterestedGridViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 1/25/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpportunityModel.h"

#import "AQGridView.h"

@interface MySharesInterestedGridViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {
    AQGridView * _gridView;
    NSArray *_guests;
    OpportunityModel *_opportunity; 

    IBOutlet UIToolbar *messageBar;
    IBOutlet UITextField *messageField;
}
@property (nonatomic) IBOutlet AQGridView * gridView;
@property (nonatomic) IBOutlet UIToolbar *messageBar;
@property (nonatomic) IBOutlet UITextField *messageField;
@property (nonatomic) NSArray *guests;
@property (nonatomic) OpportunityModel *opportunity;
- (IBAction)sendMessage:(id)sender;

@end
