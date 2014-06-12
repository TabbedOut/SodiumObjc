//
//  NACLKeyPairTests.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/11/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NACLCryptoKeyPair.h"

@interface NACLKeyPairTests : XCTestCase
@end

@implementation NACLKeyPairTests

- (void)assertKeyPairIsValid:(NACLCryptoKeyPair *)keyPair
{
    XCTAssertNotNil(keyPair, @"");
    XCTAssertNotEqual([keyPair.publicKey length], 0, @"");
    XCTAssertNotEqual([keyPair.secretKey length], 0, @"");    
}

- (void)testInit_expectSuccess
{
    NACLCryptoKeyPair *keyPair = [[NACLCryptoKeyPair alloc] init];
    
    [self assertKeyPairIsValid:keyPair];
}

- (void)testInitWithSeed_expectSuccess
{
    NSData *seed = [@"i-am-a-seed" dataUsingEncoding:NSUTF8StringEncoding];
    NACLCryptoKeyPair *keyPair = [[NACLCryptoKeyPair alloc] initWithSeed:seed];

    [self assertKeyPairIsValid:keyPair];
}

- (void)testInitWithSeed_withNilSeed
{
    NACLCryptoKeyPair *keyPairA = [[NACLCryptoKeyPair alloc] init];
    NACLCryptoKeyPair *keyPairB = [[NACLCryptoKeyPair alloc] initWithSeed:nil];
    
    XCTAssertNotEqual(keyPairA, keyPairB, @"");
    XCTAssertNotEqualObjects(keyPairA.publicKey, keyPairB.publicKey, @"");
    XCTAssertNotEqualObjects(keyPairA.secretKey, keyPairB.secretKey, @"");    
}

- (void)testCreationMethod_expectSuccess
{
    NACLCryptoKeyPair *keyPair = [NACLCryptoKeyPair keyPair];
    
    [self assertKeyPairIsValid:keyPair];
}

- (void)testCreationMethodWithSeed_expectSuccess
{
    NSData *seed = [@"i-am-a-seed" dataUsingEncoding:NSUTF8StringEncoding];
    NACLCryptoKeyPair *keyPair = [NACLCryptoKeyPair keyPairWithSeed:seed];

    [self assertKeyPairIsValid:keyPair];
}

- (void)testCopy
{
    NACLCryptoKeyPair *keyPairA = [NACLCryptoKeyPair keyPair];
    NACLCryptoKeyPair *keyPairB = [keyPairA copy];
    
    XCTAssertNotEqual(keyPairA, keyPairB, @"");
    XCTAssertEqualObjects(keyPairA.publicKey, keyPairB.publicKey, @"");
    XCTAssertEqualObjects(keyPairA.secretKey, keyPairB.secretKey, @"");
}

- (void)testIsEqual_whenEqual
{
    NACLCryptoKeyPair *keyPairA = [NACLCryptoKeyPair keyPair];
    NACLCryptoKeyPair *keyPairB = [keyPairA copy];
    
    XCTAssertTrue([keyPairA isEqual:keyPairB], @"");
    XCTAssertTrue([keyPairB isEqual:keyPairA], @"");
}

- (void)testIsEqual_withSelf
{
    NACLCryptoKeyPair *keyPairA = [NACLCryptoKeyPair keyPair];
    
    XCTAssertTrue([keyPairA isEqual:keyPairA], @"");
    XCTAssertTrue([keyPairA isEqual:keyPairA], @"");
}

- (void)testIsEqual_whenNotEqual
{
    NACLCryptoKeyPair *keyPairA = [NACLCryptoKeyPair keyPair];
    NACLCryptoKeyPair *keyPairB = [NACLCryptoKeyPair keyPair];
    
    XCTAssertFalse([keyPairA isEqual:keyPairB], @"");
    XCTAssertFalse([keyPairB isEqual:keyPairA], @"");
}

- (void)testIsEqualToKeyPair_whenEqual
{
    NACLCryptoKeyPair *keyPairA = [NACLCryptoKeyPair keyPair];
    NACLCryptoKeyPair *keyPairB = [keyPairA copy];
    
    XCTAssertTrue([keyPairA isEqualToKeyPair:keyPairB], @"");
    XCTAssertTrue([keyPairB isEqualToKeyPair:keyPairA], @"");
}

- (void)testIsEqualToKeyPair_withSelf
{
    NACLCryptoKeyPair *keyPairA = [NACLCryptoKeyPair keyPair];
    
    XCTAssertTrue([keyPairA isEqualToKeyPair:keyPairA], @"");
    XCTAssertTrue([keyPairA isEqualToKeyPair:keyPairA], @"");
}

- (void)testIsEqualToKeyPair_whenNotEqual
{
    NACLCryptoKeyPair *keyPairA = [NACLCryptoKeyPair keyPair];
    NACLCryptoKeyPair *keyPairB = [NACLCryptoKeyPair keyPair];
    
    XCTAssertFalse([keyPairA isEqualToKeyPair:keyPairB], @"");
    XCTAssertFalse([keyPairB isEqualToKeyPair:keyPairA], @"");
}

- (void)testHash_withEqualKeypairs
{
    NACLCryptoKeyPair *keyPairA = [NACLCryptoKeyPair keyPair];
    NACLCryptoKeyPair *keyPairB = [keyPairA copy];
    
    XCTAssertEqual([keyPairA hash], [keyPairB hash], @"");
    XCTAssertEqual([keyPairB hash], [keyPairA hash], @"");
}

- (void)testArchival
{
    NACLCryptoKeyPair *keyPair = [NACLCryptoKeyPair keyPair];
    NSData *encodedKeyPair = [NSKeyedArchiver archivedDataWithRootObject:keyPair];
    
    XCTAssertTrue(encodedKeyPair.length > 0, @"");
}

- (void)testUnarchival
{
    NACLCryptoKeyPair *keyPair = [NACLCryptoKeyPair keyPair];
    NSData *encodedKeyPair = [NSKeyedArchiver archivedDataWithRootObject:keyPair];
    NACLCryptoKeyPair *decodedKeyPair = [NSKeyedUnarchiver unarchiveObjectWithData:encodedKeyPair];
    
    XCTAssertTrue([keyPair isEqualToKeyPair:decodedKeyPair], @"");
}

@end
