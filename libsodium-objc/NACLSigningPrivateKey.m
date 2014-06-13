//
//  NACLSigningPrivateKey.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLSigningPrivateKey.h"
#import "NACL.h"

@implementation NACLSigningPrivateKey

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
