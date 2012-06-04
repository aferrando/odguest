//
//  Language.m
//  ilovemiciudad
//
//  Created by Gerard Porto on 12/23/10.
//  Copyright 2010 Kirubs. All rights reserved.
//

#import "Language.h"

@implementation Language

static NSBundle *bundle = nil;

+(void)initialize {
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
	NSArray* languages = [defs objectForKey:@"AppleLanguages"];
	NSString *current = [languages objectAtIndex:0];
	[self setLanguage:current];
}

/*
 example calls:
 [Language setLanguage:@"it"];
 [Language setLanguage:@"de"];
 */
+(void)setLanguage:(NSString *)l {
	//NSLog(@"preferredLang: %@", l);
	NSString *path = [[ NSBundle mainBundle ] pathForResource:l ofType:@"lproj" ];
	//NSLog(@"path: %@", path);
	bundle = [NSBundle bundleWithPath:path];
}

+(NSString *)get:(NSString *)key alter:(NSString *)alternate {
	return [bundle localizedStringForKey:key value:alternate table:nil];
}


@end
