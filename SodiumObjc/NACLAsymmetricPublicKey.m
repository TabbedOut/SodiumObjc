//
//  NACLAsymmetricPublicKey.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <sodium.h>
#import <SodiumObjc/NACL.h>
#import <SodiumObjc/NACLAsymmetricPublicKey.h>

@implementation NACLAsymmetricPublicKey

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
    return crypto_box_PUBLICKEYBYTES;
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
