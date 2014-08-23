//
//  NSDataNACLTests.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSData+NACL.h"
#import "NSString+NACL.h"

@interface NSDataNACLTests : XCTestCase

@end

@implementation NSDataNACLTests
{
    NSString *plainText;
    NSData *message;
    NACLAsymmetricKeyPair *sendersKeyPair;
    NACLAsymmetricKeyPair *receiversKeyPair;
    NACLSigningKeyPair *signersKeyPair;
    NACLSymmetricPrivateKey *privateKey;
    NACLNonce *nonce;
}

- (void)setUp
{
    [super setUp];
    
    plainText = @"I'm about to get encrypted!";
    message = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    sendersKeyPair = [NACLAsymmetricKeyPair keyPair];
    receiversKeyPair = [NACLAsymmetricKeyPair keyPair];
    signersKeyPair = [NACLSigningKeyPair keyPair];
    privateKey = [NACLSymmetricPrivateKey key];
    nonce = [NACLNonce nonce];
}

- (void)tearDown
{
    message = nil;
    sendersKeyPair = nil;
    receiversKeyPair = nil;
    privateKey = nil;
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
    NSData *encryptedData = [[message encryptedDataUsingPublicKey:sendersKeyPair.publicKey
                                                       privateKey:receiversKeyPair.privateKey
                                                            nonce:nonce] dataWithoutNonce];
    
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
    
    NSData *encryptedData = [[message encryptedDataUsingPublicKey:sendersKeyPair.publicKey
                                                       privateKey:receiversKeyPair.privateKey
                                                            nonce:nonce] dataWithoutNonce];
    NSData *decryptedData = [encryptedData decryptedDataUsingPublicKey:receiversKeyPair.publicKey 
                                                            privateKey:sendersKeyPair.privateKey
                                                                 nonce:nonce
                                                                 error:&error];
    
    XCTAssertNotNil(decryptedData, @"");
    
    NSString *decryptedMessage = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(decryptedMessage, plainText, @"");
}

- (void)testDecryptedDataWithPublicKeyPrivateKey_expectMatch
{
    NSData *encryptedData = [message encryptedDataUsingPublicKey:sendersKeyPair.publicKey
                                                      privateKey:receiversKeyPair.privateKey
                                                           nonce:nonce];
    NSData *decryptedData = [encryptedData decryptedDataUsingPublicKey:receiversKeyPair.publicKey
                                                            privateKey:sendersKeyPair.privateKey];
    
    XCTAssertNotNil(decryptedData, @"");
    
    NSString *decryptedMessage = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(decryptedMessage, plainText, @"");
}

- (void)testDecryptedDataWithPublicKeyPrivateKeyError_expectMatch
{
    NSError *error = nil;
    
    NSData *encryptedData = [message encryptedDataUsingPublicKey:sendersKeyPair.publicKey
                                                      privateKey:receiversKeyPair.privateKey
                                                           nonce:nonce];
    NSData *decryptedData = [encryptedData decryptedDataUsingPublicKey:receiversKeyPair.publicKey
                                                            privateKey:sendersKeyPair.privateKey
                                                                 error:&error];
    
    XCTAssertNotNil(decryptedData, @"");
    XCTAssertNil(error);
    
    NSString *decryptedMessage = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(decryptedMessage, plainText, @"");
}


- (void)testDecryptedTextWithKeyPairNonce_expectMatch
{
    NSData *encryptedData = [[message encryptedDataUsingPublicKey:sendersKeyPair.publicKey
                                                       privateKey:receiversKeyPair.privateKey
                                                            nonce:nonce] dataWithoutNonce];
    NSString *decryptedText = [encryptedData decryptedTextUsingPublicKey:receiversKeyPair.publicKey
                                                              privateKey:sendersKeyPair.privateKey
                                                                   nonce:nonce];
    
    XCTAssertEqualObjects(decryptedText, plainText, @"");
}

- (void)testDecryptedTextWithKeyPairNonceError_expectMatch
{
    NSError *error = nil;
    
    NSData *encryptedData = [[message encryptedDataUsingPublicKey:sendersKeyPair.publicKey
                                                       privateKey:receiversKeyPair.privateKey
                                                            nonce:nonce] dataWithoutNonce];
    NSString *decryptedText = [encryptedData decryptedTextUsingPublicKey:receiversKeyPair.publicKey 
                                                              privateKey:sendersKeyPair.privateKey
                                                                   nonce:nonce
                                                                   error:&error];
    
    XCTAssertEqualObjects(decryptedText, plainText, @"");
    XCTAssertNil(error, @"");
}

- (void)testDecryptedTextWithKeyPair_expectMatch
{
    NSData *encryptedData = [message encryptedDataUsingPublicKey:sendersKeyPair.publicKey
                                                      privateKey:receiversKeyPair.privateKey
                                                           nonce:nonce];
    NSString *decryptedText = [encryptedData decryptedTextUsingPublicKey:receiversKeyPair.publicKey
                                                              privateKey:sendersKeyPair.privateKey];
    
    XCTAssertEqualObjects(decryptedText, plainText, @"");
}

- (void)testDecryptedTextWithKeyPairError_expectMatch
{
    NSError *error = nil;
    
    NSData *encryptedData = [message encryptedDataUsingPublicKey:sendersKeyPair.publicKey
                                                      privateKey:receiversKeyPair.privateKey
                                                           nonce:nonce];
    NSString *decryptedText = [encryptedData decryptedTextUsingPublicKey:receiversKeyPair.publicKey
                                                              privateKey:sendersKeyPair.privateKey
                                                                   error:&error];
    
    XCTAssertEqualObjects(decryptedText, plainText, @"");
    XCTAssertNil(error, @"");
}

#pragma mark Signing

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

#pragma mark Private-Key Cryptography

- (void)testEncryptedDataWithPrivateKeyNonce_withValidMessage
{
    NSData *encryptedData = [message encryptedDataUsingPrivateKey:privateKey nonce:nonce];
    
    XCTAssertNotNil(encryptedData, @"");
}

- (void)testEncryptedDataWithPrivateKeyNonceError_withValidMessage
{
    NSError *error = nil;
    
    NSData *encryptedData = [message encryptedDataUsingPrivateKey:privateKey nonce:nonce error:&error];
    
    XCTAssertNotNil(encryptedData, @"");
    XCTAssertNil(error, @"");
}

- (void)testDecryptedDataWithPrivateKeyNonce_expectMatch
{
    NSData *encryptedData = [[message encryptedDataUsingPrivateKey:privateKey nonce:nonce] dataWithoutNonce];
    NSData *decryptedData = [encryptedData decryptedDataUsingPrivateKey:privateKey nonce:nonce];
    
    XCTAssertNotNil(decryptedData, @"");
    
    NSString *decryptedMessage = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(decryptedMessage, plainText, @"");
}

- (void)testDecryptedDataWithPrivateKeyNonceError_expectMatch
{
    NSError *error = nil;
    
    NSData *encryptedData = [[message encryptedDataUsingPrivateKey:privateKey nonce:nonce error:&error] dataWithoutNonce];
    NSData *decryptedData = [encryptedData decryptedDataUsingPrivateKey:privateKey nonce:nonce error:&error];
    
    XCTAssertNotNil(decryptedData, @"");
    
    NSString *decryptedMessage = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(decryptedMessage, plainText, @"");
}

- (void)testDecryptedTextWithPrivateKeyNonce_expectMatch
{
    NSData *encryptedData = [[message encryptedDataUsingPrivateKey:privateKey nonce:nonce] dataWithoutNonce];
    NSString *decryptedText = [encryptedData decryptedTextUsingPrivateKey:privateKey nonce:nonce];
    
    XCTAssertEqualObjects(decryptedText, plainText, @"");
}

- (void)testDecryptedTextWithPrivateKeyNonceError_expectMatch
{
    NSError *error = nil;
    
    NSData *encryptedData = [[message encryptedDataUsingPrivateKey:privateKey nonce:nonce] dataWithoutNonce];
    NSString *decryptedText = [encryptedData decryptedTextUsingPrivateKey:privateKey nonce:nonce error:&error];
    
    XCTAssertEqualObjects(decryptedText, plainText, @"");
    XCTAssertNil(error, @"");
}

#pragma mark Utility

- (void)testDataWithoutNonce_withPublicKeyEncryption
{
    NSData *encryptedData = [message encryptedDataUsingPublicKey:receiversKeyPair.publicKey
                                                      privateKey:sendersKeyPair.privateKey
                                                           nonce:nonce];
    NSData *encryptedDataWithoutNonce = [encryptedData dataWithoutNonce];
    
    XCTAssertTrue([encryptedData length] == ([encryptedDataWithoutNonce length] + [NACLNonce nonceLength]), @"");
}

- (void)testDataWithoutNonce_withPrivateKeyEncryption
{
    NSData *encryptedData = [message encryptedDataUsingPrivateKey:privateKey nonce:nonce];
    NSData *encryptedDataWithoutNonce = [encryptedData dataWithoutNonce];
    
    XCTAssertTrue([encryptedData length] == ([encryptedDataWithoutNonce length] + [NACLNonce nonceLength]), @"");
}

- (void)testDecryptedTextWithoutNonce_withPublicKeyDecryption
{
    NSData *encryptedData = [message encryptedDataUsingPublicKey:receiversKeyPair.publicKey
                                                      privateKey:sendersKeyPair.privateKey
                                                           nonce:nonce];
    encryptedData = [encryptedData dataWithoutNonce];

    NSError *error = nil;
    NSString *text = [encryptedData decryptedTextUsingPublicKey:sendersKeyPair.publicKey
                                                     privateKey:receiversKeyPair.privateKey
                                                          nonce:nonce
                                                          error:&error];
    
    XCTAssertNotNil(text, @"");
    XCTAssertNil(error, @"");
}

- (void)testDecryptedTextWithoutNonce_withPrivateKeyDecryption
{
    NSData *encryptedData = [message encryptedDataUsingPrivateKey:privateKey nonce:nonce];
    encryptedData = [encryptedData dataWithoutNonce];
    
    NSError *error = nil;
    NSString *text = [encryptedData decryptedTextUsingPrivateKey:privateKey nonce:nonce];
    
    XCTAssertNotNil(text, @"");
    XCTAssertNil(error, @"");
}

@end
