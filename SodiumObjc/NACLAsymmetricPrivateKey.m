//
//  NACLAsymmetricPrivateKey.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <sodium.h>
#import <Security/Security.h>
#import "NACLAsymmetricPrivateKey.h"
#import "NACL.h"
#import "NACLKeySubclass.h"

@implementation NACLAsymmetricPrivateKey

+ (void)initialize 
{
	[NACL initializeNACL];
	[super initialize];
}

+ (instancetype)key
{
    // Rely on NACLAsymmetricKeyPair to create a NACLAsymmetricKey with correct data
    return nil;
}

+ (instancetype)keyWithData:(NSData *)keyData
{
    // Rely on NACLAsymmetricKeyPair to create a NACLAsymmetricKey with correct data
    return nil;
}

+ (NSUInteger)keyLength
{
    return crypto_box_SECRETKEYBYTES;
}

- (instancetype)init
{
    // Rely on NACLAsymmetricKeyPair to create a NACLAsymmetricKey with correct data
    return nil;
}

- (NSData *)generateDefaultKeyData
{
    // Rely on NACLAsymmetricKeyPair to create this with correct data
    
    return nil;
}

@end
