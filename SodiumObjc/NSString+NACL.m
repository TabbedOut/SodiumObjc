//
//  NSString+NACL.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NSString+NACL.h"
#import "NSData+NACL.h"

@implementation NSString (NACL)

#pragma mark Public-Key Cryptography

- (NSData *)encryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                  nonce:(NACLNonce *)nonce
{
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [messageData encryptedDataUsingPublicKey:publicKey privateKey:privateKey nonce:nonce];
    
    return encryptedData;
}

- (NSData *)encryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                  nonce:(NACLNonce *)nonce 
                                  error:(NSError *__autoreleasing *)outError
{
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [messageData encryptedDataUsingPublicKey:publicKey privateKey:privateKey nonce:nonce error:outError];
    
    return encryptedData;
}

#pragma mark Signatures

- (NSData *)signedDataUsingPrivateKey:(NACLSigningPrivateKey *)privateKey
{
    return [self signedDataUsingPrivateKey:privateKey error:nil];
}

- (NSData *)signedDataUsingPrivateKey:(NACLSigningPrivateKey *)privateKey error:(NSError **)outError
{
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *signedData = [messageData signedDataUsingPrivateKey:privateKey error:outError];
    return signedData;
}

#pragma mark Private-Key Cryptography

- (NSData *)encryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey nonce:(NACLNonce *)nonce
{
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [messageData encryptedDataUsingPrivateKey:privateKey nonce:nonce];
    
    return encryptedData;
}

- (NSData *)encryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey nonce:(NACLNonce *)nonce error:(NSError **)outError
{
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [messageData encryptedDataUsingPrivateKey:privateKey nonce:nonce error:outError];
    
    return encryptedData;
}

@end
