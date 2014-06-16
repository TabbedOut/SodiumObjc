//
//  NACLAsymmetricPrivateKey.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLAsymmetricPrivateKey.h"
#import "NACL.h"

@implementation NACLAsymmetricPrivateKey

+ (void)initialize 
{
	[NACL initializeNACL];
	[super initialize];
}

+ (instancetype)key
{
    NSAssert(NO, @"Rely on NACLAsymmetricKeyPair to create a NACLAsymmetricKey with correct data");
    return nil;
}

+ (instancetype)keyWithData:(NSData *)keyData
{
    NSAssert(NO, @"Rely on NACLAsymmetricKeyPair to create a NACLAsymmetricKey with correct data");
    return nil;
}

+ (NSUInteger)keyLength
{
    return crypto_box_SECRETKEYBYTES;
}

- (instancetype)init
{
    NSAssert(NO, @"Rely on NACLAsymmetricKeyPair to create a NACLAsymmetricKey with correct data");
    return nil;
}

- (NSData *)generateDefaultKeyData
{
    // Rely on NACLAsymmetricKeyPair to create this with correct data
    
    return nil;
}

@end
