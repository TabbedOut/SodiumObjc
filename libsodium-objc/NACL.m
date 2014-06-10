//
//  NACL.m
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 Tabbedout. All rights reserved.
//

#import "NACL.h"

@implementation NACL
+ (void)initialize {
	static BOOL initialized = NO;
	if(initialized == NO){
		sodium_init();
	}
}
@end
