//
//  NSDataNACLTests.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSData+NACL.h"

@interface NSDataNACLTests : XCTestCase

@end

@implementation NSDataNACLTests
{
    NSString *plainText;
    NSData *message;
    NACLAsymmetricKeyPair *sendersKeyPair;
    NACLAsymmetricKeyPair *receiversKeyPair;
    NACLSigningKeyPair *signersKeyPair;
    NACLSymmetricSecretKey *secretKey;
    NACLNonce *nonce;
}

- (void)setUp
{
    [super setUp];
    
    plainText = @"I about to get encrypted!";
    message = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    sendersKeyPair = [NACLAsymmetricKeyPair keyPair];
    receiversKeyPair = [NACLAsymmetricKeyPair keyPair];
    signersKeyPair = [NACLSigningKeyPair keyPair];
    secretKey = [NACLSymmetricSecretKey key];
    nonce = [NACLNonce nonce];
}

- (void)tearDown
{
    message = nil;
    sendersKeyPair = nil;
    receiversKeyPair = nil;
    secretKey = nil;
    nonce = nil;
    
    [super tearDown];
}

#pragma mark Public-Key Cryptography

- (void)testEncryptedDataWithPublicKeyPrivateKeyNonce_withValidMessage
{
    NSData *encryptedData = [message encryptedDataUsingPublicKey:sendersKeyPair.publicKey 
                                                      privateKey:receiversKeyPair.privateKey 
                                                           nonce:nonce];
    
    XCTAssertNotNil(encryptedData, @"");
}

- (void)testEncryptedDataWithPublicKeyPrivateKeyNonceError_withValidMessage
{
    NSError *error = nil;
    
    NSData *encryptedData = [message encryptedDataUsingPublicKey:sendersKeyPair.publicKey 
                                                      privateKey:receiversKeyPair.privateKey
                                                           nonce:nonce 
                                                           error:&error];
    
    XCTAssertNotNil(encryptedData, @"");
    XCTAssertNil(error, @"");
}


- (void)testDecryptedDataWithPublicKeyPrivateKeyNonce_expectSuccess
{
    NSData *encryptedData = [message encryptedDataUsingPublicKey:sendersKeyPair.publicKey 
                                                      privateKey:receiversKeyPair.privateKey
                                                           nonce:nonce];
    NSData *decryptedData = [encryptedData decryptedDataUsingPublicKey:receiversKeyPair.publicKey 
                                                            privateKey:sendersKeyPair.privateKey
                                                                 nonce:nonce];
    
    XCTAssertNotNil(decryptedData, @"");
    
    NSString *decryptedMessage = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(decryptedMessage, plainText, @"");
}

- (void)testDecryptedDataWithPublicKeyPrivateKeyNonceError_expectMatch
{
    NSError *error = nil;
    
    NSData *encryptedData = [message encryptedDataUsingPublicKey:sendersKeyPair.publicKey
                                                      privateKey:receiversKeyPair.privateKey
                                                           nonce:nonce];
    NSData *decryptedData = [encryptedData decryptedDataUsingPublicKey:receiversKeyPair.publicKey 
                                                            privateKey:sendersKeyPair.privateKey
                                                                 nonce:nonce
                                                                 error:&error];
    
    XCTAssertNotNil(decryptedData, @"");
    
    NSString *decryptedMessage = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(decryptedMessage, plainText, @"");
}

- (void)testDecryptedTextWithKeyPairNonce_expectMatch
{
    NSData *encryptedData = [message encryptedDataUsingPublicKey:sendersKeyPair.publicKey
                                                      privateKey:receiversKeyPair.privateKey 
                                                           nonce:nonce];
    NSString *decryptedText = [encryptedData decryptedTextUsingPublicKey:receiversKeyPair.publicKey
                                                              privateKey:sendersKeyPair.privateKey
                                                                   nonce:nonce];
    
    XCTAssertEqualObjects(decryptedText, plainText, @"");
}

- (void)testDecryptedTextWithKeyPairNonceError_expectMatch
{
    NSError *error = nil;
    
    NSData *encryptedData = [message encryptedDataUsingPublicKey:sendersKeyPair.publicKey 
                                                      privateKey:receiversKeyPair.privateKey
                                                           nonce:nonce];
    NSString *decryptedText = [encryptedData decryptedTextUsingPublicKey:receiversKeyPair.publicKey 
                                                              privateKey:sendersKeyPair.privateKey
                                                                   nonce:nonce
                                                                   error:&error];
    
    XCTAssertEqualObjects(decryptedText, plainText, @"");
    XCTAssertNil(error, @"");
}

- (void)testSignedDataUsingKeyPairError
{
    NSError *error = nil;
    
    NSData *signedData = [message signedDataUsingPrivateKey:signersKeyPair.privateKey error:&error];
    
    XCTAssertTrue(signedData.length > 0, @"");
}

- (void)testVerifiedDataUsingPublicKeyError
{
    NSError *error = nil;
    
    NSData *signedData = [message signedDataUsingPrivateKey:signersKeyPair.privateKey error:&error];
    NSData *verifiedData = [signedData verifiedDataUsingPublicKey:signersKeyPair.publicKey error:&error];

    XCTAssertEqualObjects(verifiedData, message, @"");
}

- (void)testVerifiedTextUsingPublicKeyError
{
    NSError *error = nil;
    
    NSData *signedData = [message signedDataUsingPrivateKey:signersKeyPair.privateKey error:&error];
    NSString *verifiedText = [signedData verifiedTextUsingPublicKey:signersKeyPair.publicKey error:&error];
    
    XCTAssertEqualObjects(verifiedText, plainText, @"");
}

#pragma mark Secret-Key Cryptography

- (void)testEncryptedDataWithSecretKeyNonce_withValidMessage
{
    NSData *encryptedData = [message encryptedDataUsingSecretKey:secretKey nonce:nonce];
    
    XCTAssertNotNil(encryptedData, @"");
}

- (void)testEncryptedDataWithSecretKeyNonceError_withValidMessage
{
    NSError *error = nil;
    
    NSData *encryptedData = [message encryptedDataUsingSecretKey:secretKey nonce:nonce error:&error];
    
    XCTAssertNotNil(encryptedData, @"");
    XCTAssertNil(error, @"");
}

- (void)testDecryptedDataWithSecretKeyNonce_expectMatch
{
    NSData *encryptedData = [message encryptedDataUsingSecretKey:secretKey nonce:nonce];
    NSData *decryptedData = [encryptedData decryptedDataUsingSecretKey:secretKey nonce:nonce];
    
    XCTAssertNotNil(decryptedData, @"");
    
    NSString *decryptedMessage = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(decryptedMessage, plainText, @"");
}

- (void)testDecryptedDataWithSecretKeyNonceError_expectMatch
{
    NSError *error = nil;
    
    NSData *encryptedData = [message encryptedDataUsingSecretKey:secretKey nonce:nonce error:&error];
    NSData *decryptedData = [encryptedData decryptedDataUsingSecretKey:secretKey nonce:nonce error:&error];
    
    XCTAssertNotNil(decryptedData, @"");
    
    NSString *decryptedMessage = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(decryptedMessage, plainText, @"");
}

- (void)testDecryptedTextWithSecretKeyNonce_expectMatch
{
    NSData *encryptedData = [message encryptedDataUsingSecretKey:secretKey nonce:nonce];
    NSString *decryptedText = [encryptedData decryptedTextUsingSecretKey:secretKey nonce:nonce];
    
    XCTAssertEqualObjects(decryptedText, plainText, @"");
}

- (void)testDecryptedTextWithSecretKeyNonceError_expectMatch
{
    NSError *error = nil;
    
    NSData *encryptedData = [message encryptedDataUsingSecretKey:secretKey nonce:nonce];
    NSString *decryptedText = [encryptedData decryptedTextUsingSecretKey:secretKey nonce:nonce error:&error];
    
    XCTAssertEqualObjects(decryptedText, plainText, @"");
    XCTAssertNil(error, @"");
}

@end
