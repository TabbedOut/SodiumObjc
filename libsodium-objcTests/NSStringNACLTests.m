//
//  NSStringNACLTests.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+NACL.h"

@interface NSStringNACLTests : XCTestCase

@end

@implementation NSStringNACLTests
{
    NSString *plainText;
    NACLCryptoKeyPair *sendersKeyPair;
    NACLCryptoKeyPair *receiversKeyPair;
    NACLSecretKey *secretKey;
    NACLNonce *nonce;
}

- (void)setUp
{
    [super setUp];
    
    plainText = @"I am about to get encrypted!";
    sendersKeyPair = [NACLCryptoKeyPair keyPair];
    receiversKeyPair = [NACLCryptoKeyPair keyPair];
    secretKey = [NACLSecretKey secretKey];
    nonce = [NACLNonce nonce];
}

- (void)tearDown
{
    sendersKeyPair = nil;
    receiversKeyPair = nil;
    secretKey = nil;
    nonce = nil;
    
    [super tearDown];
}

- (void)testEncryptedDataWithPublicKeySecretKeyNonce
{
    NSData *encryptedData = [plainText encryptedDataUsingPublicKey:sendersKeyPair.publicKey secretKey:receiversKeyPair.secretKey nonce:nonce];
    
    XCTAssert(encryptedData.length > 0, @"");
}

- (void)testEncryptedDataWithPublicKeySecretKeyNonceError
{
    NSError *error = nil;
    NSData *encryptedData = [plainText encryptedDataUsingPublicKey:sendersKeyPair.publicKey secretKey:receiversKeyPair.secretKey nonce:nonce error:&error];
    
    XCTAssert(encryptedData.length > 0, @"");
}

- (void)testEncryptedDataWithSecretKeyNonce
{
    NSData *encryptedData = [plainText encryptedDataUsingSecretKey:secretKey nonce:nonce];
    
    XCTAssert(encryptedData.length > 0, @"");
}

- (void)testEncryptedDataWithSecretKeyNonceError
{
    NSError *error = nil;
    NSData *encryptedData = [plainText encryptedDataUsingSecretKey:secretKey nonce:nonce error:&error];
    
    XCTAssert(encryptedData.length > 0, @"");
}

@end
