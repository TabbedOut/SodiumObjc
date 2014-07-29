//
//  NACLAsymmetricPrivateKeyTests.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <sodium.h>
#import <XCTest/XCTest.h>
#import "NACLAsymmetricKeyPair.h"

@interface NACLAsymmetricPrivateKey (Testing)

- (NSData *)generateDefaultKeyData;

@end

@interface NACLAsymmetricPrivateKeyTests : XCTestCase

@end

@implementation NACLAsymmetricPrivateKeyTests
{
    NACLAsymmetricKeyPair *keyPair;
}

- (void)setUp
{
    keyPair = [NACLAsymmetricKeyPair keyPair];
}

- (void)tearDown
{
    keyPair = nil;
    [super tearDown];
}

- (void)assertKeyIsValid:(NACLAsymmetricPrivateKey *)privateKey
{
    XCTAssertNotNil(privateKey, @"");
    XCTAssertNotNil(privateKey.data, @"");
    XCTAssertTrue(privateKey.data.length > 0, @"");
}

- (void)testCopy
{
    NACLAsymmetricPrivateKey *copy = [keyPair.privateKey copy];
    
    XCTAssertNotNil(copy, @"");
    XCTAssertNotEqual(keyPair.privateKey, copy, @"");
    XCTAssertEqualObjects(keyPair.privateKey.data, copy.data, @"");
}

- (void)testIsEqual_whenSame
{
    NACLAsymmetricPrivateKey *privateKey = keyPair.privateKey;
    NACLAsymmetricPrivateKey *same = privateKey;
    
    XCTAssertTrue([privateKey isEqual:same], @"");
    XCTAssertTrue([same isEqual:privateKey], @"");
}

- (void)testIsEqual_whenEqual
{
    NACLAsymmetricPrivateKey *copy = [keyPair.privateKey copy];
    
    XCTAssertTrue([keyPair.privateKey isEqual:copy], @"");
    XCTAssertTrue([copy isEqual:keyPair.privateKey], @"");
}

- (void)testIsEqual_whenNotEqual
{
    NACLAsymmetricKeyPair *keyPairA = [NACLAsymmetricKeyPair keyPair];
    NACLAsymmetricKeyPair *keyPairB = [NACLAsymmetricKeyPair keyPair];
    
    XCTAssertFalse([keyPairA.privateKey isEqual:keyPairB.privateKey], @"");
    XCTAssertFalse([keyPairB.privateKey isEqual:keyPairA.privateKey], @"");
}

- (void)testIsEqual_withNil
{
    XCTAssertFalse([keyPair.privateKey isEqual:nil], @"");    
}

- (void)testIsEqualToPrivateKey_whenSame
{
    NACLAsymmetricPrivateKey *same = keyPair.privateKey;
    
    XCTAssertTrue([keyPair.privateKey isEqualToKey:same], @"");
    XCTAssertTrue([same isEqualToKey:keyPair.privateKey], @"");
}

- (void)testIsEqualToPrivateKey_whenEqual
{
    NACLAsymmetricPrivateKey *copy = [keyPair.privateKey copy];
    
    XCTAssertTrue([keyPair.privateKey isEqualToKey:copy], @"");
    XCTAssertTrue([copy isEqualToKey:keyPair.privateKey], @"");
}

- (void)testIsEqualToKey_whenNotEqual
{
    NACLAsymmetricKeyPair *keyPairA = [NACLAsymmetricKeyPair keyPair];
    NACLAsymmetricKeyPair *keyPairB = [NACLAsymmetricKeyPair keyPair];
    
    XCTAssertFalse([keyPairA.privateKey isEqualToKey:keyPairB.privateKey], @"");
    XCTAssertFalse([keyPairB.privateKey isEqualToKey:keyPairA.privateKey], @"");
}

- (void)testIsEqualToPrivateKey_withNil
{
    XCTAssertFalse([keyPair.privateKey isEqualToKey:nil], @"");
}

- (void)testHash
{
    NACLAsymmetricPrivateKey *copy = [keyPair.privateKey copy];
    
    XCTAssertEqual(keyPair.privateKey.hash, copy.hash, @"");
}

- (void)testArchival
{
    NSData *encodedprivateKey = [NSKeyedArchiver archivedDataWithRootObject:keyPair.privateKey];
    
    XCTAssertTrue(encodedprivateKey.length > 0, @"");
}

- (void)testUnarchival
{
    NSData *encodedprivateKey = [NSKeyedArchiver archivedDataWithRootObject:keyPair.privateKey];
    NACLAsymmetricPrivateKey *decodedprivateKey = [NSKeyedUnarchiver unarchiveObjectWithData:encodedprivateKey];
    
    XCTAssertTrue([keyPair.privateKey isEqualToKey:decodedprivateKey], @"");
}

- (void)testKey_expectNil
{
    // Nil is expected because NACLAsymmetricKeyPair is leverated to create the private key
    
    XCTAssertNil([NACLAsymmetricPrivateKey key], @"");
}

- (void)testKeyWithData_expectNil
{
    // Nil is expected because NACLAsymmetricKeyPair is leverated to create the private key
    
    XCTAssertNil([NACLAsymmetricPrivateKey keyWithData:[NSData data]], @"");
}

- (void)testInit_expectNil
{
    // Nil is expected because NACLAsymmetricKeyPair is leverated to create the private key
    
    XCTAssertNil([[NACLAsymmetricPrivateKey alloc] init], @"");
}

- (void)testKeyLength
{
    // Ensure the implementation doesn't diverge
    
    XCTAssertEqual([NACLAsymmetricPrivateKey keyLength], crypto_box_SECRETKEYBYTES, @"");
}

- (void)testGenerateKeyData_expectNil
{
    XCTAssertNil([keyPair.privateKey generateDefaultKeyData], @"");
}

@end
