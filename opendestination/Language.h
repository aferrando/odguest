//
//  Language.h
//  ilovemiciudad
//
//  Created by Gerard Porto on 12/23/10.
//  Copyright 2010 Kirubs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Language : NSObject {

}

+(void)initialize;
+(void)setLanguage:(NSString *)l;
+(NSString *)get:(NSString *)key alter:(NSString *)alternate;

@end
