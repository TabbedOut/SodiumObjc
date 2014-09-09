//
//  NACLSigningPrivateKey.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <sodium.h>
#import <SodiumObjc/NACL.h>
#import <SodiumObjc/NACLSigningPrivateKey.h>
#import <SodiumObjc/NSData+NACL.h>
#import <SodiumObjc/NSString+NACL.h>

@implementation NACLSigningPrivateKey

+ (void)initialize 
{
	[NACL initializeNACL];
	[super initialize];
}

+ (NSUInteger)keyLength
{
    return crypto_sign_SECRETKEYBYTES;
}

- (NSData *)generateDefaultKeyData
{
    // Rely on NACLSigningKeyPair to create this with correct data
    
    return nil;
}

- (NSData *)signedDataFromText:(NSString *)text
{
    return [text signedDataUsingPrivateKey:self];
}

- (NSData *)signedDataFromText:(NSString *)text error:(NSError *__autoreleasing *)outError
{
    return [text signedDataUsingPrivateKey:self error:outError];
}

- (NSData *)signedDataFromData:(NSData *)data
{
    return [data signedDataUsingPrivateKey:self];
}

- (NSData *)signedDataFromData:(NSData *)data error:(NSError *__autoreleasing *)outError
{
    return [data signedDataUsingPrivateKey:self error:outError];
}

@end
