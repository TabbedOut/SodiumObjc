//
//  NACLPublicKey.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACL.h"
#import "NACLPublicKey.h"
#import "NACLKeySubclass.h"

@implementation NACLPublicKey

+ (void)initialize 
{
	[NACL initializeNACL];
	[super initialize];
}

- (NSData *)generateDefaultKeyData
{
    // Rely on NACLAsymmetricKeyPair to create this with correct data
    
    return nil;
}

@end
