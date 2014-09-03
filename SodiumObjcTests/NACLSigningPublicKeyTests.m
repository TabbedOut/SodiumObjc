//
//  NACLSigningPublicKeyTests.m
//  SodiumObjc
//
//  Created by Damian Carrillo on 8/27/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <sodium.h>
#import <XCTest/XCTest.h>
#import "NACLSigningKeyPair.h"

@interface NACLSigningPublicKey (Testing)

- (NSData *)generateDefaultKeyData;

@end

@interface NACLSigningPublicKeyTests : XCTestCase

@end

@implementation NACLSigningPublicKeyTests
{
    NACLSigningKeyPair *signingKeyPair;
}

- (void)setUp
{
    signingKeyPair = [NACLSigningKeyPair keyPair];
}

- (void)tearDown
{
    signingKeyPair = nil;
}

- (void)testKeyData
{
    XCTAssertNotNil(signingKeyPair.publicKey.data, @"");
}

- (void)testKeyLength
{
    XCTAssertEqual([NACLSigningPublicKey keyLength], crypto_sign_PUBLICKEYBYTES, @"");
}

- (void)testGenerateDefaultKeyData
{
    XCTAssertNil([signingKeyPair.publicKey generateDefaultKeyData], @"");
}

- (void)testVerifiedTextFromSignedData
{
    NSString *expectedText = @"text";
    
    NSData *signedData = [signingKeyPair.privateKey signedDataFromText:expectedText];
    NSString *verifiedText = [signingKeyPair.publicKey verifiedTextFromSignedData:signedData];
    
    XCTAssertEqualObjects(verifiedText, expectedText, @"");
}

- (void)testVerifiedTextFromSignedDataError
{
    NSError *error = nil;
    NSString *expectedText = @"text";
    
    NSData *signedData = [signingKeyPair.privateKey signedDataFromText:expectedText];
    NSString *verifiedText = [signingKeyPair.publicKey verifiedTextFromSignedData:signedData error:&error];
    
    XCTAssertEqualObjects(verifiedText, expectedText, @"");
    XCTAssertNil(error, @"");
}

- (void)testVerifiedDataFromSignedData
{
    NSData *unsignedData = [@"text" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *signedData = [signingKeyPair.privateKey signedDataFromData:unsignedData];
    NSData *verifiedData = [signingKeyPair.publicKey verifiedDataFromSignedData:signedData];
    
    XCTAssertEqualObjects(unsignedData, verifiedData, @"");
}

- (void)testVerifiedDataFromSignedDataError
{
    NSError *error = nil;
    NSData *unsignedData = [@"text" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *signedData = [signingKeyPair.privateKey signedDataFromData:unsignedData];
    NSData *verifiedData = [signingKeyPair.publicKey verifiedDataFromSignedData:signedData error:&error];
    
    XCTAssertEqualObjects(unsignedData, verifiedData, @"");
    XCTAssertNil(error, @"");
}

@end
