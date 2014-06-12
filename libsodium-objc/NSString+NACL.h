//
//  NSString+NACL.h
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NACLCryptoKeyPair.h"
#import "NACLNonce.h"
#import "NACLSecretKey.h"

@interface NSString (NACL)

#pragma mark Public-Key Cryptography

- (NSData *)encryptedDataUsingPublicKey:(NSData *)publicKey secretKey:(NSData *)secretKey nonce:(NACLNonce *)nonce;
- (NSData *)encryptedDataUsingPublicKey:(NSData *)publicKey secretKey:(NSData *)secretKey nonce:(NACLNonce *)nonce error:(NSError **)outError;

#pragma mark Secret-Key Cryptography

- (NSData *)encryptedDataUsingSecretKey:(NACLSecretKey *)secretKey nonce:(NACLNonce *)nonce;
- (NSData *)encryptedDataUsingSecretKey:(NACLSecretKey *)secretKey nonce:(NACLNonce *)nonce error:(NSError **)outError;

@end
