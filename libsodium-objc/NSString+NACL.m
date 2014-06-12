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

- (NSData *)encryptedDataUsingPublicKey:(NSData *)publicKey 
                            secretKey:(NSData *)secretKey
                                 nonce:(NACLNonce *)nonce
{
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [messageData encryptedDataUsingPublicKey:publicKey secretKey:secretKey nonce:nonce];
    
    return encryptedData;
}

- (NSData *)encryptedDataUsingPublicKey:(NSData *)publicKey 
                            secretKey:(NSData *)secretKey
                               nonce:(NACLNonce *)nonce 
                               error:(NSError *__autoreleasing *)outError
{
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [messageData encryptedDataUsingPublicKey:publicKey secretKey:secretKey nonce:nonce error:outError];
    
    return encryptedData;
}

#pragma mark Secret-Key Cryptography

- (NSData *)encryptedDataUsingSecretKey:(NACLSecretKey *)secretKey nonce:(NACLNonce *)nonce
{
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [messageData encryptedDataUsingSecretKey:secretKey nonce:nonce];
    
    return encryptedData;
}

- (NSData *)encryptedDataUsingSecretKey:(NACLSecretKey *)secretKey nonce:(NACLNonce *)nonce error:(NSError **)outError
{
    NSData *messageData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [messageData encryptedDataUsingSecretKey:secretKey nonce:nonce error:outError];
    
    return encryptedData;
}

@end
