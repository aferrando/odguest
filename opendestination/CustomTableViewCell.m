//
//  CustomTableviewCell.m
//  Created by David Hoyos on 14/04/10.
//  Copyright 2011 None. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "NSDate+Helper.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"

@implementation CustomTableViewCell

@synthesize subviewsDict;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        subviewsDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        mydeals=FALSE;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"touchEventFromCell" object:event];
    [super touchesBegan:touches withEvent:event];
}

-(void) loadViews:(OpportunityModel *)opportunity   userModel:(UserModel *)user{
    
    UIView * content = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 80)];
    
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 6.0, 62, 62)];
    [[self subviewsDict] setObject:imageView forKey:@"imageView"];
    [content addSubview:imageView];
    
    
    
    NSString *type=[opportunity type];
    NSString *imageName=@"15-tags.png";
    if ([type isEqualToString: @"deal"]) {
            //In case that the opportunity is a deal the orange corner is shown
        UIImageView * cornerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,50.0,50.0)];
        [cornerImage setImage:[UIImage imageNamed:@"cornerleft.png"]];
        [cornerImage setCenter:CGPointMake(26, 28)];
        [content addSubview:cornerImage];
        UIImageView * typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,13.0f,13.0f)];
        [typeImage setImage:[UIImage imageNamed:imageName]];
        [typeImage setCenter:CGPointMake(15 , 15)];
        [content addSubview:typeImage];
        // ...
    } else if ([type isEqualToString: @"event"]) {
        imageName=@"83-calendar.png";
            //In case that the opportunity is a deal the orange corner is shown
        UIImageView * cornerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,50.0,50.0)];
        [cornerImage setImage:[UIImage imageNamed:@"cornerleftGreen.png"]];
        [cornerImage setCenter:CGPointMake(26, 28)];
        [content addSubview:cornerImage];
        UIImageView * typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,13.0f,13.0f)];
        [typeImage setImage:[UIImage imageNamed:imageName]];
        [typeImage setCenter:CGPointMake(15 , 15)];
        [content addSubview:typeImage];
    } else if ([type isEqualToString: @"info"]) {
            //     imageName=@"42-info.png";
    }
/*    UIImageView * typeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,13.0f,13.0f)];
    [typeImage setImage:[UIImage imageNamed:imageName]];
    [typeImage setCenter:CGPointMake(228, 60)];
    [content addSubview:typeImage];
    
 */   
    imageName=@"ribbonlow.png";
    UIImageView * status = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,30,50)];
    [status setImage:[UIImage imageNamed:imageName]];
    [status setCenter:CGPointMake(280, 22)];
    [content addSubview:status];
    
    UILabel * ribbonLabel = [[UILabel alloc] initWithFrame:CGRectMake(269, 7, 20, 24)];
    ribbonLabel.font = [UIFont boldSystemFontOfSize:14];
    ribbonLabel.textColor = [UIColor whiteColor];
    [ribbonLabel setShadowColor:[UIColor blackColor]];
    [ribbonLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [ribbonLabel setMinimumFontSize:10.0];
    ribbonLabel.backgroundColor = [UIColor clearColor];
    ribbonLabel.numberOfLines = 1;
    ribbonLabel.textAlignment = UITextAlignmentCenter;
    [[self subviewsDict] setObject:ribbonLabel forKey:@"ribbonLabel"];
    [content addSubview:ribbonLabel];
    
    UILabel * scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(268, 1, 24, 10)];
    scoreLabel.font = [UIFont boldSystemFontOfSize:6];
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.text = @"SCORE";
    [scoreLabel setShadowColor:[UIColor blackColor]];
    [scoreLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [scoreLabel setMinimumFontSize:10.0];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.numberOfLines = 1;
    scoreLabel.textAlignment = UITextAlignmentCenter;
    // [[self subviewsDict] setObject:scoreLabel forKey:@"ribbonLabel"];
    [content addSubview:scoreLabel];
    
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 6.0, 192, 24)];
    textLabel.font = [UIFont boldSystemFontOfSize:17];
    textLabel.textColor = [UIColor whiteColor];
    [textLabel setShadowColor:[UIColor blackColor]];
    [textLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    [textLabel setMinimumFontSize:10.0];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.numberOfLines = 1;
    [[self subviewsDict] setObject:textLabel forKey:@"textLabel"];
    [content addSubview:textLabel];
    
    imageName=@"78-stopwatch.png";
    UIImageView * time = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,13.0f,13.0f)];
    [time setImage:[UIImage imageNamed:imageName]];
    [time setCenter:CGPointMake(75, 40)];
    [content addSubview:time];
    
    UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 20, 180, 40)];
    descLabel.font = [UIFont systemFontOfSize:10];
    [descLabel setMinimumFontSize:10.0];
    descLabel.textColor = [UIColor whiteColor];
    [descLabel setShadowColor:[UIColor blackColor]];
    [descLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.numberOfLines = 1;
    [[self subviewsDict] setObject:descLabel forKey:@"descLabel"];
    [content addSubview:descLabel];
    
    imageName=@"07-map-marker.png";
    UIImageView * dist = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,10.0f,13.0f)];
    [dist setImage:[UIImage imageNamed:imageName]];
    [dist setCenter:CGPointMake(75, 60)];
    [content addSubview:dist];
    
    UILabel * distLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 40, 200, 40)];
    distLabel.font = [UIFont systemFontOfSize:10];
    [distLabel setMinimumFontSize:10.0];
    distLabel.textColor = [UIColor whiteColor];
    [distLabel setShadowColor:[UIColor blackColor]];
    [distLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    distLabel.backgroundColor = [UIColor clearColor];
    distLabel.numberOfLines = 1;
    [[self subviewsDict] setObject:distLabel forKey:@"distLabel"];
    [content addSubview:distLabel];
    
    imageName=@"29-heart.png";
    UIImageView * intImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,13.0f,13.0f)];
    [intImage setImage:[UIImage imageNamed:imageName]];
    [intImage setCenter:CGPointMake(248, 60)];
    [content addSubview:intImage];
    
    UILabel * interestedLabel = [[UILabel alloc] initWithFrame:CGRectMake(258.0, 40, 100, 40)];
    interestedLabel.font = [UIFont systemFontOfSize:10];
    [interestedLabel setMinimumFontSize:10.0];
    interestedLabel.textColor = [UIColor whiteColor];
    [interestedLabel setShadowColor:[UIColor blackColor]];
    [interestedLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    interestedLabel.backgroundColor = [UIColor clearColor];
    interestedLabel.numberOfLines = 1;
    [[self subviewsDict] setObject:interestedLabel forKey:@"interestedLabel"];
    [content addSubview:interestedLabel];
    
    imageName=@"04-eye.png";
    intImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,20.0,15.0f)];
    [intImage setImage:[UIImage imageNamed:imageName]];
    [intImage setCenter:CGPointMake(278, 60)];
    [content addSubview:intImage];
    
    interestedLabel = [[UILabel alloc] initWithFrame:CGRectMake(292, 40, 100, 40)];
    interestedLabel.font = [UIFont systemFontOfSize:10];
    [interestedLabel setMinimumFontSize:10.0];
    interestedLabel.textColor = [UIColor whiteColor];
    [interestedLabel setShadowColor:[UIColor blackColor]];
    [interestedLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
    interestedLabel.backgroundColor = [UIColor clearColor];
    interestedLabel.numberOfLines = 1;
    [[self subviewsDict] setObject:interestedLabel forKey:@"notInterestedLabel"];
    [content addSubview:interestedLabel];
    
    NSMutableDictionary * dict = self.subviewsDict;
    NSURL * url = [NSURL URLWithString:[opportunity thumbURL]];
#warning imageView disactivated
    [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cell_image_placeholder.png"]];
    
    if (mydeals) {
        if ([type isEqualToString:@"deal"] && opportunity.status == OpportunityStatusInterested) {
            [(UILabel *)[dict objectForKey:@"pointsLabel"] setText:[NSString stringWithFormat:@"%d",[opportunity points]]];
            [(UIImageView *)[dict objectForKey:@"badget"] setHidden:NO];
            [(UILabel *)[dict objectForKey:@"pointsLabel"] setHidden:NO];
        }
        [content setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"list-item.png"]]];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    else {
        if ( ( opportunity.status == OpportunityStatusPendant  || opportunity.status == OpportunityStatusWatched) && (opportunity.points > 0 ) )
        {
            [(UILabel *)[dict objectForKey:@"pointsLabel"] setText:[NSString stringWithFormat:@"%d",[opportunity points]]];
            [(UIImageView *)[dict objectForKey:@"badget"] setHidden:NO];
            [(UILabel *)[dict objectForKey:@"pointsLabel"] setHidden:NO];
            [content setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"list-item.png"]]];
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
        }
        else
        {
            
            
            UIView * coverView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 80)];
            [coverView setBackgroundColor:[UIColor blackColor]];
            [coverView setAlpha:0.3];
            
            self.accessoryType = UITableViewCellAccessoryNone;
            
            [content addSubview:coverView];
            
            self.userInteractionEnabled = NO;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.alpha=0.2;
            [(UIImageView *)[dict objectForKey:@"badget"]  setImage:[UIImage imageNamed:@"Owned_Stamp.png"]];
            //   [(UIImageView *)[dict objectForKey:@"badget"] setHidden:YES];
            [(UILabel *)[dict objectForKey:@"pointsLabel"] setHidden:YES];
        }
    }
    
   /* if (opportunity.status == OpportunityStatusWalkin) {
        UIView * coverView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 80)];
        [coverView setBackgroundColor:[UIColor blackColor]];
        [coverView setAlpha:0.5];
        
        self.accessoryType = UITableViewCellAccessoryNone;
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                              initWithFrame:CGRectMake(20, 20, 40, 40)];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [indicator startAnimating];
        UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 170, 40)];
        textLabel.font = [UIFont boldSystemFontOfSize:17];
        textLabel.textColor = [UIColor orangeColor];
        [textLabel setShadowColor:[UIColor blackColor]];
        [textLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
        [textLabel setMinimumFontSize:10.0];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.numberOfLines = 2;
        textLabel.text=NSLocalizedString(@"waitingKey", @"Being validated");
        
        [content addSubview:coverView];
        [content addSubview:indicator];
        [content addSubview:textLabel];
        
        self.userInteractionEnabled = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.alpha=0.2;
        
    }*/
    [self.contentView addSubview:content];
    [[dict objectForKey:@"textLabel"] setText:[opportunity name]];
    NSTimeInterval timeInSeconds = [[opportunity endDate] timeIntervalSinceDate:[opportunity startDate]];
    double hours = timeInSeconds / 3600;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, HH:mm"];
    
    [[dict objectForKey:@"descLabel"] setText:[[NSString alloc] 
                                               initWithFormat:@"(%@ - %@)",[format stringFromDate:[opportunity startDate] ]
                                               ,[format stringFromDate:[opportunity endDate] ]
                                               ]];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:[opportunity latitude] longitude:[opportunity longitude]];
    
    
    CLLocationDistance distanceBetween = [user.myLocation
                                          distanceFromLocation:locB];
    NSLocale *currentUsersLocale = [NSLocale currentLocale];
    NSLog(@"Current Locale: %@", [currentUsersLocale localeIdentifier]);
    
    NSString *tripString = [[NSString alloc] 
                            initWithFormat:@"%.2f %@", 
                            distanceBetween/1000, @"km"];
    [[dict objectForKey:@"distLabel"] setText:tripString];
    int score=[opportunity numInterests]*2+[opportunity numNotInterests]*(-2)+[opportunity numWatchs]+[opportunity numWalkin]*3+[opportunity numConsume]*4;
    [[dict objectForKey:@"ribbonLabel"] setText:[[NSString alloc] 
                                                 initWithFormat:@"%d",score ]];
    
    [[dict objectForKey:@"interestedLabel"] setText:[[NSString alloc] 
                                                     initWithFormat:@"%d", 
                                                     [opportunity numInterests] ]];
    int total=[opportunity getScore];
    [[dict objectForKey:@"notInterestedLabel"] setText:[[NSString alloc] 
                                                        initWithFormat:@"%d",total ]];
    NSLog(@"%@: opportunity type ", [opportunity type]);
    
}
- (void) setMyDeals:(BOOL)mydeals2{
    mydeals=mydeals2;
}



@end
