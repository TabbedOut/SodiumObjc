//
//  NACLSigningPublicKey.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <sodium.h>
#import <SodiumObjc/NACL.h>
#import <SodiumObjc/NACLSigningPublicKey.h>
#import <SodiumObjc/NSString+NACL.h>
#import <SodiumObjc/NSData+NACL.h>

@implementation NACLSigningPublicKey

+ (void)initialize 
{
	[NACL initializeNACL];
	[super initialize];
}

+ (NSUInteger)keyLength
{
    return crypto_sign_PUBLICKEYBYTES;
}

- (NSData *)generateDefaultKeyData
{
    // Rely on NACLSigningKeyPair to create this with correct data
    
    return nil;
}

- (NSString *)verifiedTextFromSignedData:(NSData *)data
{
    return [data verifiedTextUsingPublicKey:self];
}

- (NSString *)verifiedTextFromSignedData:(NSData *)data error:(NSError **)outError
{
    return [data verifiedTextUsingPublicKey:self error:outError];
}

- (NSData *)verifiedDataFromSignedData:(NSData *)data
{
    return [data verifiedDataUsingPublicKey:self];
}

- (NSData *)verifiedDataFromSignedData:(NSData *)data error:(NSError **)outError
{
    return [data verifiedDataUsingPublicKey:self error:outError];
}

+ (NSUInteger)signatureLength
{
    return crypto_sign_BYTES;
}

@end
