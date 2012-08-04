//
//  PopUpViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 7/27/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpportunityModel.h"
@interface PopUpViewController : UIViewController
{
OpportunityModel * _opportunity;
}
@property ( nonatomic ) OpportunityModel * opportunity;

@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@end
