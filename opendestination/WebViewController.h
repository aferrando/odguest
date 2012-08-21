//
//  WebViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 8/20/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController{
    NSString *urlAddress;
}
@property (strong, nonatomic) IBOutlet UIWebView *webview;
-(void) setUrl:(NSString *) url;
@end
