//
//  MeteoViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 8/8/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "MeteoViewController.h"
#import "DDXML.h"
#import "DDXMLDocument.h"
#import <QuartzCore/QuartzCore.h>


@interface MeteoViewController ()

@end

@implementation MeteoViewController
@synthesize lowTempLabel;
@synthesize currentImage;
@synthesize currentTempLabel;
@synthesize placeLabel;
@synthesize backgroundView;
@synthesize tempFLabel;
@synthesize imageplus1;
@synthesize imageplus3;
@synthesize imageplus2;
@synthesize dayplus1;
@synthesize dayplus2;
@synthesize dayplus3;
@synthesize tempplus1;
@synthesize tempplus2;
@synthesize tempplus3;
@synthesize currentWeatherLabel;
@synthesize templow1;
@synthesize templow2;
@synthesize templow3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=NSLocalizedString(@"weatherKey", @"");
    backgroundView.layer.masksToBounds = YES;
    backgroundView.layer.cornerRadius = 5.0;
    backgroundView.layer.borderWidth = 1;
        //  backgroundView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"brillant.png"]];
    backgroundView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    
    backgroundView.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
    
    backgroundView.layer.shadowOpacity = 1.0f;
    
    backgroundView.layer.shadowRadius = 10.0f;
   
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    NSString *tmp = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com/ig/api?weather=V0N1B4&hl=en"] encoding:NSUTF8StringEncoding error:nil];
    NSData *xmlData = [tmp dataUsingEncoding:NSUTF8StringEncoding];
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil] ;
    NSArray *currentData = [xmlDoc nodesForXPath:@"//forecast_information/city" error:nil];
    for(DDXMLElement *res in currentData){
        NSString *tt = [[res attributeForName:@"data"] stringValue];
        NSLog(@"low: %@",tt);
        placeLabel.text=tt;
    }
   NSArray *resultNodes = nil;
    resultNodes = [xmlDoc nodesForXPath:@"//current_conditions/condition" error:nil];
    for(DDXMLElement* resultElement in resultNodes){
        NSString *condition = [[resultElement attributeForName:@"data"] stringValue];
            //NSString *imageName=[NSString stringWithFormat:@"%@.png", condition];
        [currentImage setImage:[self imageFromConditions:condition]];
        [currentWeatherLabel setText:condition];
     /*   NSLog(@"%@", temp);
        tempLabel.text=temp;*/
   }
     currentData = [xmlDoc nodesForXPath:@"//current_conditions/temp_f" error:nil];
    for(DDXMLElement *res in currentData){
        NSString *tt = [[res attributeForName:@"data"] stringValue];
        NSLog(@"low: %@",tt);
        currentTempLabel.text=[NSString stringWithFormat:@"%@°", tt];
    }
 /*   
    currentData = [xmlDoc nodesForXPath:@"//current_conditions/temp_c" error:nil];
    for(DDXMLElement *res in currentData){
        NSString *tt = [[res attributeForName:@"data"] stringValue];
        NSLog(@"low: %@",tt);
        tempFLabel.text=[NSString stringWithFormat:@"%@ °C", tt];
    }*/
    
    NSArray *lowsData = [xmlDoc nodesForXPath:@"//forecast_conditions/high" error:nil];
    for(DDXMLElement *res in lowsData){
        NSString *tt = [[res attributeForName:@"data"] stringValue];
        NSLog(@"low: %@",tt);
        lowTempLabel.text=[NSString stringWithFormat:@"%@ °C", tt];
    }
    
    lowsData = [xmlDoc nodesForXPath:@"//forecast_conditions/low" error:nil];
    for(DDXMLElement *res in lowsData){
        NSString *tt = [[res attributeForName:@"data"] stringValue];
        NSLog(@"low: %@",tt);
        lowTempLabel.text=[NSString stringWithFormat:@"%@ °C", tt];
    }
    
    lowsData = [xmlDoc nodesForXPath:@"//forecast_conditions/condition" error:nil];
    int i=1;
    for(DDXMLElement *res in lowsData){
        NSString *tt = [[res attributeForName:@"data"] stringValue];
        NSLog(@"low: %@",tt);
        switch (i) {
            case 1:
                [imageplus1 setImage:[self imageFromConditions:tt]];
                break;
                
            case 2:
                [imageplus2 setImage:[self imageFromConditions:tt]];
                break;
                
            case 3:
                [imageplus3 setImage:[self imageFromConditions:tt]];
                break;
                
            default:
                break;
        }
        i++;
        
    }
    
    lowsData = [xmlDoc nodesForXPath:@"//forecast_conditions/high" error:nil];
    i=1;
    for(DDXMLElement *res in lowsData){
        NSString *tt = [[res attributeForName:@"data"] stringValue];
        NSLog(@"low: %@",tt);
        switch (i) {
            case 1:
                tempplus1.text=[NSString stringWithFormat:@"%@°", tt];
                break;
                
            case 2:
                tempplus2.text=[NSString stringWithFormat:@"%@°", tt];
                break;
                
            case 3:
                tempplus3.text=[NSString stringWithFormat:@"%@°", tt];
                break;
                
            default:
                break;
        }
        i++;
        
    }
    lowsData = [xmlDoc nodesForXPath:@"//forecast_conditions/low" error:nil];
   i=1;
    for(DDXMLElement *res in lowsData){
        NSString *tt = [[res attributeForName:@"data"] stringValue];
        NSLog(@"low: %@",tt);
        switch (i) {
            case 1:
                templow1.text=[NSString stringWithFormat:@"%@°", tt];
                break;
                
            case 2:
                templow2.text=[NSString stringWithFormat:@"%@°", tt];
                break;
                
            case 3:
                templow3.text=[NSString stringWithFormat:@"%@°", tt];
                break;
                
            default:
                break;
        }
        i++;
        
    }
    
    lowsData = [xmlDoc nodesForXPath:@"//forecast_conditions/day_of_week" error:nil];
    i=1;
    for(DDXMLElement *res in lowsData){
        NSString *tt = [[res attributeForName:@"data"] stringValue];
        NSLog(@"low: %@",tt);
        switch (i) {
            case 1:
                dayplus1.text=[NSString stringWithFormat:@"%@", tt];
                break;
                
            case 2:
                dayplus2.text=[NSString stringWithFormat:@"%@", tt];
                break;
                
            case 3:
                dayplus3.text=[NSString stringWithFormat:@"%@", tt];
                break;
                
            default:
                break;
        }
        i++;
        
    }
    
}
- (UIImage *) imageFromConditions:(NSString *) conditions {
    /*
     Clear 
     Cloudy 
     Fog
     Haze 
     Light Rain
     Mostly Cloudy 
     Overcast 
     Partly Cloudy
     Rain 
     Rain Showers 
     Showers
     Thunderstorm 
     Chance of Showers 
     Chance of Snow 
     Chance of Storm 
     Mostly Sunny
     Partly Sunny 
     Scattered Showers 
     Sunny*/
    if ([conditions isEqualToString:@"Clear"])
        return [UIImage imageNamed:@"Clear.png"];
    if ([conditions isEqualToString:@"Cloudy"])
        return [UIImage imageNamed:@"morecloudy.png"];
    if ([conditions isEqualToString:@"Fog"])
        return [UIImage imageNamed:@"fog.png"];
    if ([conditions isEqualToString:@"Haze"])
        return [UIImage imageNamed:@"fog.png"];
    if ([conditions isEqualToString:@"Light Rain"])
        return [UIImage imageNamed:@"lightrain.png"];
    if ([conditions isEqualToString:@"Mostly Cloudy"])
        return [UIImage imageNamed:@"mostcloudy.png"];
    if ([conditions isEqualToString:@"Overcast"])
        return [UIImage imageNamed:@"mostcloudy.png"];
    if ([conditions isEqualToString:@"Partly Cloudy"])
        return [UIImage imageNamed:@"barelycloudy.png"];
    if ([conditions isEqualToString:@"Partly Cloudy"])
        return [UIImage imageNamed:@"barelycloudy.png"];
    if ([conditions isEqualToString:@"Rain"])
        return [UIImage imageNamed:@"heavyrain.png"];
    if ([conditions isEqualToString:@"Rain Showers"])
        return [UIImage imageNamed:@"heavyrain.png"];
    
    if ([conditions isEqualToString:@"Showers"])
        return [UIImage imageNamed:@"lightrain.png"];
    
    if ([conditions isEqualToString:@"Thunderstorm"])
        return [UIImage imageNamed:@"thunderstorm.png"];
    
    if ([conditions isEqualToString:@"Chance of Showers"])
        return [UIImage imageNamed:@"lightrain.png"];
    
    if ([conditions isEqualToString:@"Chance of Snow"])
        return [UIImage imageNamed:@"lightsnow.png"];
    
    if ([conditions isEqualToString:@"Chance of Storm"])
        return [UIImage imageNamed:@"thunderstorm.png"];
    
    if ([conditions isEqualToString:@"Mostly Sunny"])
        return [UIImage imageNamed:@"fullsun.png"];
    
    if ([conditions isEqualToString:@"Partly Sunny"])
        return [UIImage imageNamed:@"barelycloudy.png"];
    
    if ([conditions isEqualToString:@"Scattered Showers"])
        return [UIImage imageNamed:@"lightrain.png"];
    
    if ([conditions isEqualToString:@"Sunny"])
        return [UIImage imageNamed:@"fullsun.png"];
    
    return [UIImage imageNamed:@"Clear.png"];
}
- (void)viewDidUnload
{
    [self setLowTempLabel:nil];
    [self setCurrentTempLabel:nil];
    [self setCurrentImage:nil];
    [self setPlaceLabel:nil];
    [self setBackgroundView:nil];
    [self setTempFLabel:nil];
    [self setImageplus1:nil];
    [self setImageplus3:nil];
    [self setImageplus2:nil];
    [self setDayplus1:nil];
    [self setDayplus2:nil];
    [self setDayplus3:nil];
    [self setTempplus1:nil];
    [self setTempplus2:nil];
    [self setTempplus3:nil];
    [self setCurrentWeatherLabel:nil];
    [self setTemplow1:nil];
    [self setTemplow2:nil];
    [self setTemplow3:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
