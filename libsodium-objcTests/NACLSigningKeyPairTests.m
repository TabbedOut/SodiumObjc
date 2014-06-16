//
//  NACLSigningKeyPairTests.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NACLSigningKeyPair.h"

@interface NACLSigningKeyPairTests : XCTestCase

@end

@implementation NACLSigningKeyPairTests

- (void)assertSigningKeyPairIsValid:(NACLSigningKeyPair *)keyPair
{
    XCTAssertNotNil(keyPair, @"");
    XCTAssertNotNil(keyPair.publicKey, @"");
    XCTAssertNotNil(keyPair.privateKey, @"");
    XCTAssertNotEqual([keyPair.publicKey.data length], 0, @"");
    XCTAssertNotEqual([keyPair.privateKey.data length], 0, @"");    
}

- (void)testInit_expectSuccess
{
    NACLSigningKeyPair *keyPair = [[NACLSigningKeyPair alloc] init];
    
    [self assertSigningKeyPairIsValid:keyPair];
}

- (void)testInitWithSeed_expectSuccess
{
    NSData *seed = [@"i-am-a-seed. i-am-a-seed. i-am-a-seed." dataUsingEncoding:NSUTF8StringEncoding];
    NSRange seedRange = {0, [NACLSigningKeyPair seedLength]};
    seed = [seed subdataWithRange:seedRange];
    
    NACLSigningKeyPair *keyPair = [[NACLSigningKeyPair alloc] initWithSeed:seed];
    
    [self assertSigningKeyPairIsValid:keyPair];
}

- (void)testInitWithSeed_withNilSeed
{
    NACLSigningKeyPair *keyPairA = [[NACLSigningKeyPair alloc] init];
    NACLSigningKeyPair *keyPairB = [[NACLSigningKeyPair alloc] initWithSeed:nil];
    
    XCTAssertNotEqual(keyPairA, keyPairB, @"");
    XCTAssertNotEqualObjects(keyPairA.publicKey, keyPairB.publicKey, @"");
    XCTAssertNotEqualObjects(keyPairA.privateKey, keyPairB.privateKey, @"");    
}

- (void)testCreationMethod_expectSuccess
{
    NACLSigningKeyPair *keyPair = [NACLSigningKeyPair keyPair];
    
    [self assertSigningKeyPairIsValid:keyPair];
}

- (void)testCreationMethodWithSeed_expectSuccess
{
    NSData *seed = [@"i-am-a-seed. i-am-a-seed. i-am-a-seed." dataUsingEncoding:NSUTF8StringEncoding];
    NSRange seedRange = {0, [NACLSigningKeyPair seedLength]};
    seed = [seed subdataWithRange:seedRange];
    
    NACLSigningKeyPair *keyPair = [NACLSigningKeyPair keyPairWithSeed:seed];
    
    [self assertSigningKeyPairIsValid:keyPair];
}

- (void)testCopy
{
    NACLSigningKeyPair *keyPairA = [NACLSigningKeyPair keyPair];
    NACLSigningKeyPair *keyPairB = [keyPairA copy];
    
    XCTAssertNotEqual(keyPairA, keyPairB, @"");
    XCTAssertEqualObjects(keyPairA.publicKey, keyPairB.publicKey, @"");
    XCTAssertEqualObjects(keyPairA.privateKey, keyPairB.privateKey, @"");
}

- (void)testIsEqual_whenEqual
{
    NACLSigningKeyPair *keyPairA = [NACLSigningKeyPair keyPair];
    NACLSigningKeyPair *keyPairB = [keyPairA copy];
    
    XCTAssertTrue([keyPairA isEqual:keyPairB], @"");
    XCTAssertTrue([keyPairB isEqual:keyPairA], @"");
}

- (void)testIsEqual_withSelf
{
    NACLSigningKeyPair *keyPairA = [NACLSigningKeyPair keyPair];
    
    XCTAssertTrue([keyPairA isEqual:keyPairA], @"");
    XCTAssertTrue([keyPairA isEqual:keyPairA], @"");
}

- (void)testIsEqual_whenNotEqual
{
    NACLSigningKeyPair *keyPairA = [NACLSigningKeyPair keyPair];
    NACLSigningKeyPair *keyPairB = [NACLSigningKeyPair keyPair];
    
    XCTAssertFalse([keyPairA isEqual:keyPairB], @"");
    XCTAssertFalse([keyPairB isEqual:keyPairA], @"");
}

- (void)testIsEqualToKeyPair_whenEqual
{
    NACLSigningKeyPair *keyPairA = [NACLSigningKeyPair keyPair];
    NACLSigningKeyPair *keyPairB = [keyPairA copy];
    
    XCTAssertTrue([keyPairA isEqualToKeyPair:keyPairB], @"");
    XCTAssertTrue([keyPairB isEqualToKeyPair:keyPairA], @"");
}

- (void)testIsEqualToKeyPair_withSelf
{
    NACLSigningKeyPair *keyPairA = [NACLSigningKeyPair keyPair];
    
    XCTAssertTrue([keyPairA isEqualToKeyPair:keyPairA], @"");
    XCTAssertTrue([keyPairA isEqualToKeyPair:keyPairA], @"");
}

- (void)testIsEqualToKeyPair_whenNotEqual
{
    NACLSigningKeyPair *keyPairA = [NACLSigningKeyPair keyPair];
    NACLSigningKeyPair *keyPairB = [NACLSigningKeyPair keyPair];
    
    XCTAssertFalse([keyPairA isEqualToKeyPair:keyPairB], @"");
    XCTAssertFalse([keyPairB isEqualToKeyPair:keyPairA], @"");
}

- (void)testHash_withEqualKeypairs
{
    NACLSigningKeyPair *keyPairA = [NACLSigningKeyPair keyPair];
    NACLSigningKeyPair *keyPairB = [keyPairA copy];
    
    XCTAssertEqual([keyPairA hash], [keyPairB hash], @"");
    XCTAssertEqual([keyPairB hash], [keyPairA hash], @"");
}

- (void)testArchival
{
    NACLSigningKeyPair *keyPair = [NACLSigningKeyPair keyPair];
    NSData *encodedKeyPair = [NSKeyedArchiver archivedDataWithRootObject:keyPair];
    
    XCTAssertTrue(encodedKeyPair.length > 0, @"");
}

- (void)testUnarchival
{
    NACLSigningKeyPair *keyPair = [NACLSigningKeyPair keyPair];
    NSData *encodedKeyPair = [NSKeyedArchiver archivedDataWithRootObject:keyPair];
    NACLSigningKeyPair *decodedKeyPair = [NSKeyedUnarchiver unarchiveObjectWithData:encodedKeyPair];
    
    XCTAssertTrue([keyPair isEqualToKeyPair:decodedKeyPair], @"");
}


@end
