//
//  GuestGridViewCell.m
//  opendestination
//
//  Created by Albert Ferrando on 1/25/12.
//  Copyright (c) 2012 None. All rights reserved.
//


#import "GuestGridViewCell.h"

@implementation GuestGridViewCell
@synthesize imageView = _imageView, statusView = _statusView, title, user=_user ;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return ( nil );
    
    _imageView = [[UIImageView alloc] initWithFrame: CGRectZero];
    _statusView = [[UIImageView alloc] initWithFrame: CGRectZero];
    _title = [[UILabel alloc] initWithFrame: CGRectZero];
    _title.highlightedTextColor = [UIColor whiteColor];
    _title.font = [UIFont boldSystemFontOfSize: 12.0];
    _title.adjustsFontSizeToFitWidth = YES;
    _title.minimumFontSize = 10.0;
    
    [self.contentView addSubview: _imageView];
    self.selectedBackgroundView=[[UIImageView alloc] initWithFrame: CGRectZero]; 
    self.selectedBackgroundView.backgroundColor=[UIColor greenColor];
    
    [self.contentView addSubview: _title];
    self.contentView.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_statusView];
    return ( self );
}


- (CALayer *) glowSelectionLayer
{
    return ( self.contentView.layer );
}

- (UserModel *) user
{
    return ( _user);
}

- (void) setUser:(UserModel *)user
{
    _user=user;
    switch (user.userStatus) {
        case 0:
            _statusView.image=[UIImage imageNamed:@"redStatus.png"];
            break;
        case 1:
            _statusView.image=[UIImage imageNamed:@"greenStatus.png"];
            break;
            
        default:_statusView.image=[UIImage imageNamed:@"blackStatus.png"];
            break;
    }
    [self setNeedsLayout];
}
- (UIImage *) image
{
    return ( _imageView.image );
}

- (void) setImage: (UIImage *) anImage
{
    _imageView.image = anImage;
    [self setNeedsLayout];
}
- (NSString *) title
{
    return ( _title.text );
}

- (void) setTitle: (NSString *) title
{
    _title.text = title;
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize imageSize = _imageView.image.size;
    CGRect frame = _imageView.frame;
    CGRect bounds = self.contentView.bounds;
    //    [_title sizeToFit];
    // CGRect frame = _title.frame;
    frame.size.width = MIN(frame.size.width, bounds.size.width);
    frame.origin.y = CGRectGetMaxY(bounds) - frame.size.height;
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    _statusView.frame=CGRectMake(85, 0, 15 , 15);
    _title.frame = CGRectMake(0, 92, 90 , 15);
    _title.backgroundColor = [UIColor clearColor];
    _title.textAlignment = UITextAlignmentCenter;
    _title.textColor=[UIColor whiteColor];
    
    if ( (imageSize.width <= bounds.size.width) &&
        (imageSize.height <= bounds.size.height) )
    {
        return;
    }
    
    // scale it down to fit
    CGFloat hRatio = bounds.size.width / imageSize.width;
    CGFloat vRatio = bounds.size.height / imageSize.height;
    CGFloat ratio = MAX(hRatio, vRatio);
    
    frame.size.width = floorf(imageSize.width * ratio);
    frame.size.height = floorf(imageSize.height * ratio);
    frame.origin.x = floorf((bounds.size.width - frame.size.width) * 0.5);
    frame.origin.y = floorf((bounds.size.height - frame.size.height) * 0.5);
    _imageView.frame = frame;
}

@end
