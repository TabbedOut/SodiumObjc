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
    NACLAsymmetricKeyPair *sendersKeyPair;
    NACLAsymmetricKeyPair *receiversKeyPair;
    NACLSigningKeyPair *signingKeyPair;
    NACLSymmetricPrivateKey *secretKey;
    NACLNonce *nonce;
}

- (void)setUp
{
    [super setUp];
    
    plainText = @"I am about to get encrypted.";
    sendersKeyPair = [NACLAsymmetricKeyPair keyPair];
    receiversKeyPair = [NACLAsymmetricKeyPair keyPair];
    signingKeyPair = [NACLSigningKeyPair keyPair];
    secretKey = [NACLSymmetricPrivateKey key];
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
    NSData *encryptedData = [plainText encryptedDataUsingPublicKey:sendersKeyPair.publicKey 
                                                        privateKey:receiversKeyPair.privateKey 
                                                             nonce:nonce];
    
    XCTAssert(encryptedData.length > 0, @"");
}

- (void)testEncryptedDataWithPublicKeySecretKeyNonceError
{
    NSError *error = nil;
    NSData *encryptedData = [plainText encryptedDataUsingPublicKey:sendersKeyPair.publicKey 
                                                        privateKey:receiversKeyPair.privateKey 
                                                             nonce:nonce error:&error];
    
    XCTAssert(encryptedData.length > 0, @"");
}

- (void)testSignedDataUsingSecretKeyNonce
{
    NSError *error = nil;
    NSData *signedData = [plainText signedDataUsingPrivateKey:signingKeyPair.privateKey error:&error];

    XCTAssertTrue(signedData.length > 0, @"");
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
