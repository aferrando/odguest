//
//  GuestGridViewCell.h
//  opendestination
//
//  Created by Albert Ferrando on 1/25/12.
//  Copyright (c) 2012 None. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AQGridViewCell.h"
#import "UserModel.h"

@interface GuestGridViewCell : AQGridViewCell
{
    UIImageView * _imageView;
    UIImageView * _statusView;
    UILabel *_title;
    UserModel *_user;
}
@property (nonatomic) UIImage * image;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIImageView *statusView;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic  ) UserModel *user;


@end
