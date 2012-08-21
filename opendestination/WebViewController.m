//
//  WebViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 8/20/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize webview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    /*    NSString *urlAddress = @"http://www.facebook.com/thyon4vallees";
        
            //Create a URL object.
        NSURL *url = [NSURL URLWithString:urlAddress];
        
            //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
            //Load the request in the UIWebView.
        [webview loadRequest:requestObj];*/
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        //NSString *urlAddress = @"http://www.facebook.com/thyon4vallees";
    
        //Create a URL object.
   
    
    [webview loadHTMLString:@"<html><body style=\"background-color:black;\"></body></html>" baseURL:nil];
    
        //the more the delay the errors will be less so within 0.1-0.3 would be fine
    [self performSelector:@selector(loadURL:) withObject:nil afterDelay:0.1];

    // Do any additional setup after loading the view from its nib.
}

-(void)loadURL:(id)sender{
    [webview stopLoading]; //added this line to stop the previous request
    NSURL *url = [NSURL URLWithString:urlAddress];
    
        //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
        //Load the request in the UIWebView.
    [webview loadRequest:requestObj];
}
-(void) setUrl:(NSString *) url{
    urlAddress = url;
    
   
}
- (void)viewDidUnload
{
    [self setWebview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
