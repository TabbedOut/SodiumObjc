//
//  NACL.m
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACL.h"

NSString *const NACLErrorDomain = @"NACLErrorDomain";

@implementation NACL

+ (void)initializeNACL
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sodium_init();
    });
}

@end
