//
//  NACLSigningPrivateKeyTests.m
//  SodiumObjc
//
//  Created by Damian Carrillo on 8/27/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <sodium.h>
#import "NACLSigningKeyPair.h"

@interface NACLSigningPrivateKey (Testing)

- (NSData *)generateDefaultKeyData;

@end

@interface NACLSigningPrivateKeyTests : XCTestCase

@end

@implementation NACLSigningPrivateKeyTests
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

- (void)testKeyLength
{
    XCTAssertEqual([NACLSigningPrivateKey keyLength], crypto_sign_SECRETKEYBYTES, @"");
}

- (void)testGenerateDefaultKeyData
{
    XCTAssertNil([signingKeyPair.privateKey generateDefaultKeyData], @"");
}

- (void)testSignedDataFromText
{
    NSData *signedData = [signingKeyPair.privateKey signedDataFromText:@"text"];
    
    XCTAssertTrue([signedData length] > 0, @"");
}

- (void)testSignedDataFromData
{
    NSData *unsignedData = [@"text" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *signedData = [signingKeyPair.privateKey signedDataFromData:unsignedData];
    
    XCTAssertTrue([signedData length] > 0, @"");
}

- (void)testSignedDataFromDataError
{
    NSError *error = nil;
    NSData *unsignedData = [@"text" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *signedData = [signingKeyPair.privateKey signedDataFromData:unsignedData error:&error];
    
    XCTAssertTrue([signedData length] > 0, @"");
    XCTAssertNil(error, @"");
}

- (void)testSignedDataFromTextError
{
    NSError *error = nil;
    NSData *signedData = [signingKeyPair.privateKey signedDataFromText:@"text" error:&error];
    
    XCTAssertTrue([signedData length] > 0, @"");
    XCTAssertNil(error, @"");
}

@end
