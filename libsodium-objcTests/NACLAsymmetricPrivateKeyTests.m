//
//  NACLAsymmetricPrivateKeyTests.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NACLAsymmetricKeyPair.h"

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

- (void)assertKeyIsValid:(NACLAsymetricPrivateKey *)privateKey
{
    XCTAssertNotNil(privateKey, @"");
    XCTAssertNotNil(privateKey.data, @"");
    XCTAssertTrue(privateKey.data.length > 0, @"");
}

- (void)testCopy
{
    NACLAsymetricPrivateKey *copy = [keyPair.privateKey copy];
    
    XCTAssertNotNil(copy, @"");
    XCTAssertNotEqual(keyPair.privateKey, copy, @"");
    XCTAssertEqualObjects(keyPair.privateKey.data, copy.data, @"");
}

- (void)testIsEqual_whenSame
{
    NACLAsymetricPrivateKey *privateKey = keyPair.privateKey;
    NACLAsymetricPrivateKey *same = privateKey;
    
    XCTAssertTrue([privateKey isEqual:same], @"");
    XCTAssertTrue([same isEqual:privateKey], @"");
}

- (void)testIsEqual_whenEqual
{
    NACLAsymetricPrivateKey *copy = [keyPair.privateKey copy];
    
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
    NACLAsymetricPrivateKey *same = keyPair.privateKey;
    
    XCTAssertTrue([keyPair.privateKey isEqualToKey:same], @"");
    XCTAssertTrue([same isEqualToKey:keyPair.privateKey], @"");
}

- (void)testIsEqualToPrivateKey_whenEqual
{
    NACLAsymetricPrivateKey *copy = [keyPair.privateKey copy];
    
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
    NACLAsymetricPrivateKey *copy = [keyPair.privateKey copy];
    
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
    NACLAsymetricPrivateKey *decodedprivateKey = [NSKeyedUnarchiver unarchiveObjectWithData:encodedprivateKey];
    
    XCTAssertTrue([keyPair.privateKey isEqualToKey:decodedprivateKey], @"");
}

@end
