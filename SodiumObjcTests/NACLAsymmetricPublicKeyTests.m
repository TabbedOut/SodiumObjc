//
//  NACLAsymmetricPublicKeyTests.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NACLAsymmetricKeyPair.h"

@interface NACLAsymmetricPublicKeyTests : XCTestCase

@end

@implementation NACLAsymmetricPublicKeyTests
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

- (void)assertKeyIsValid:(NACLAsymmetricPublicKey *)publicKey
{
    XCTAssertNotNil(publicKey, @"");
    XCTAssertNotNil(publicKey.data, @"");
    XCTAssertTrue(publicKey.data.length > 0, @"");
}

- (void)testCopy
{
    NACLAsymmetricPublicKey *copy = [keyPair.publicKey copy];
    
    XCTAssertNotNil(copy, @"");
    XCTAssertNotEqual(keyPair.publicKey, copy, @"");
    XCTAssertEqualObjects(keyPair.publicKey.data, copy.data, @"");
}

- (void)testIsEqual_whenSame
{
    NACLAsymmetricPublicKey *publicKey = keyPair.publicKey;
    NACLAsymmetricPublicKey *same = publicKey;
    
    XCTAssertTrue([publicKey isEqual:same], @"");
    XCTAssertTrue([same isEqual:publicKey], @"");
}

- (void)testIsEqual_whenEqual
{
    NACLAsymmetricPublicKey *copy = [keyPair.publicKey copy];
    
    XCTAssertTrue([keyPair.publicKey isEqual:copy], @"");
    XCTAssertTrue([copy isEqual:keyPair.publicKey], @"");
}

- (void)testIsEqual_whenNotEqual
{
    NACLAsymmetricKeyPair *keyPairA = [NACLAsymmetricKeyPair keyPair];
    NACLAsymmetricKeyPair *keyPairB = [NACLAsymmetricKeyPair keyPair];
    
    XCTAssertFalse([keyPairA.publicKey isEqual:keyPairB.publicKey], @"");
    XCTAssertFalse([keyPairB.publicKey isEqual:keyPairA.publicKey], @"");
}

- (void)testIsEqual_withNil
{
    XCTAssertFalse([keyPair.publicKey isEqual:nil], @"");    
}

- (void)testIsEqualToPrivateKey_whenSame
{
    NACLAsymmetricPublicKey *same = keyPair.publicKey;
    
    XCTAssertTrue([keyPair.publicKey isEqualToKey:same], @"");
    XCTAssertTrue([same isEqualToKey:keyPair.publicKey], @"");
}

- (void)testIsEqualToPrivateKey_whenEqual
{
    NACLAsymmetricPublicKey *copy = [keyPair.publicKey copy];
    
    XCTAssertTrue([keyPair.publicKey isEqualToKey:copy], @"");
    XCTAssertTrue([copy isEqualToKey:keyPair.publicKey], @"");
}

- (void)testIsEqualToKey_whenNotEqual
{
    NACLAsymmetricKeyPair *keyPairA = [NACLAsymmetricKeyPair keyPair];
    NACLAsymmetricKeyPair *keyPairB = [NACLAsymmetricKeyPair keyPair];
    
    XCTAssertFalse([keyPairA.publicKey isEqualToKey:keyPairB.publicKey], @"");
    XCTAssertFalse([keyPairB.publicKey isEqualToKey:keyPairA.publicKey], @"");
}

- (void)testIsEqualToPrivateKey_withNil
{
    XCTAssertFalse([keyPair.publicKey isEqualToKey:nil], @"");
}

- (void)testHash
{
    NACLAsymmetricPublicKey *copy = [keyPair.publicKey copy];
    
    XCTAssertEqual(keyPair.publicKey.hash, copy.hash, @"");
}

- (void)testArchival
{
    NSData *encodedprivateKey = [NSKeyedArchiver archivedDataWithRootObject:keyPair.publicKey];
    
    XCTAssertTrue(encodedprivateKey.length > 0, @"");
}

- (void)testUnarchival
{
    NSData *encodedPublicKey = [NSKeyedArchiver archivedDataWithRootObject:keyPair.publicKey];
    NACLAsymmetricPublicKey *decodedPublicKey = [NSKeyedUnarchiver unarchiveObjectWithData:encodedPublicKey];
    
    XCTAssertTrue([keyPair.publicKey isEqualToKey:decodedPublicKey], @"");
}

@end
