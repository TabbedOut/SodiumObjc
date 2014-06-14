//
//  NACLPrivateKeyTests.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NACLSymmetricPrivateKey.h"

@interface NACLSymmetricPrivateKeyTests : XCTestCase
@end

@implementation NACLSymmetricPrivateKeyTests

- (void)assertKeyIsValid:(NACLSymmetricPrivateKey *)privateKey
{
    XCTAssertNotNil(privateKey, @"");
    XCTAssertNotNil(privateKey.data, @"");
    XCTAssertEqual(privateKey.data.length, NACLSymmetricPrivateKeyByteCount, @"");
}

- (void)testInit
{
    NACLSymmetricPrivateKey *privateKey = [[NACLSymmetricPrivateKey alloc] init];
    
    [self assertKeyIsValid:privateKey];
}

- (void)testInitWithData_withValidData
{   
    NSMutableData *data = [NSMutableData dataWithLength:NACLSymmetricPrivateKeyByteCount];
    [[NSInputStream inputStreamWithFileAtPath:@"/dev/urandom"] read:(uint8_t *) [data mutableBytes] 
                                                          maxLength:NACLSymmetricPrivateKeyByteCount];
    
    NACLSymmetricPrivateKey *privateKey = [[NACLSymmetricPrivateKey alloc] initWithData:data];
    
    [self assertKeyIsValid:privateKey];
}

- (void)testPrivateKey
{
    NACLSymmetricPrivateKey *privateKey = [NACLSymmetricPrivateKey key];
    
    [self assertKeyIsValid:privateKey];
}

- (void)testPrivateKeyWithData
{
    NSMutableData *data = [NSMutableData dataWithLength:NACLSymmetricPrivateKeyByteCount];
    [[NSInputStream inputStreamWithFileAtPath:@"/dev/urandom"] read:(uint8_t *) [data mutableBytes] 
                                                          maxLength:NACLSymmetricPrivateKeyByteCount];
    
    NACLSymmetricPrivateKey *privateKey = [NACLSymmetricPrivateKey keyWithData:data];
    
    [self assertKeyIsValid:privateKey];
}

- (void)testCopy
{
    NACLSymmetricPrivateKey *privateKey = [NACLSymmetricPrivateKey key];
    NACLSymmetricPrivateKey *copy = [privateKey copy];
    
    XCTAssertNotNil(copy, @"");
    XCTAssertNotEqual(privateKey, copy, @"");
    XCTAssertEqualObjects(privateKey.data, copy.data, @"");
}

- (void)testIsEqual_whenSame
{
    NACLSymmetricPrivateKey *privateKey = [NACLSymmetricPrivateKey key];
    NACLSymmetricPrivateKey *same = privateKey;
    
    XCTAssertTrue([privateKey isEqual:same], @"");
    XCTAssertTrue([same isEqual:privateKey], @"");
}

- (void)testIsEqual_whenEqual
{
    NACLSymmetricPrivateKey *privateKey = [NACLSymmetricPrivateKey key];
    NACLSymmetricPrivateKey *copy = [privateKey copy];
    
    XCTAssertTrue([privateKey isEqual:copy], @"");
    XCTAssertTrue([copy isEqual:privateKey], @"");
}

- (void)testIsEqual_whenNotEqual
{
    NACLSymmetricPrivateKey *privateKeyA = [NACLSymmetricPrivateKey key];
    NACLSymmetricPrivateKey *privateKeyB = [NACLSymmetricPrivateKey key];
    
    XCTAssertFalse([privateKeyA isEqual:privateKeyB], @"");
    XCTAssertFalse([privateKeyB isEqual:privateKeyA], @"");
}

- (void)testIsEqual_withNil
{
    NACLSymmetricPrivateKey *privateKeyA = [NACLSymmetricPrivateKey key];
    
    XCTAssertFalse([privateKeyA isEqual:nil], @"");    
}

- (void)testIsEqualToPrivateKey_whenSame
{
    NACLSymmetricPrivateKey *privateKey = [NACLSymmetricPrivateKey key];
    NACLSymmetricPrivateKey *same = privateKey;
    
    XCTAssertTrue([privateKey isEqualToKey:same], @"");
    XCTAssertTrue([same isEqualToKey:privateKey], @"");
}

- (void)testIsEqualToPrivateKey_whenEqual
{
    NACLSymmetricPrivateKey *privateKey = [NACLSymmetricPrivateKey key];
    NACLSymmetricPrivateKey *copy = [privateKey copy];
    
    XCTAssertTrue([privateKey isEqualToKey:copy], @"");
    XCTAssertTrue([copy isEqualToKey:privateKey], @"");
}

- (void)testIsEqualToPrivateKey_whenNotEqual
{
    NACLSymmetricPrivateKey *privateKeyA = [NACLSymmetricPrivateKey key];
    NACLSymmetricPrivateKey *privateKeyB = [NACLSymmetricPrivateKey key];
    
    XCTAssertFalse([privateKeyA isEqualToKey:privateKeyB], @"");
    XCTAssertFalse([privateKeyB isEqualToKey:privateKeyA], @"");
}

- (void)testIsEqualToPrivateKey_withNil
{
    NACLSymmetricPrivateKey *privateKeyA = [NACLSymmetricPrivateKey key];
    
    XCTAssertFalse([privateKeyA isEqualToKey:nil], @"");
}

- (void)testHash
{
    NACLSymmetricPrivateKey *privateKeyA = [NACLSymmetricPrivateKey key];
    NACLSymmetricPrivateKey *copy = [privateKeyA copy];
    
    XCTAssertEqual(privateKeyA.hash, copy.hash, @"");
}

- (void)testArchival
{
    NACLSymmetricPrivateKey *privateKey = [NACLSymmetricPrivateKey key];    
    NSData *encodedPrivateKey = [NSKeyedArchiver archivedDataWithRootObject:privateKey];
    
    XCTAssertTrue(encodedPrivateKey.length > 0, @"");
}

- (void)testUnarchival
{
    NACLSymmetricPrivateKey *privateKey = [NACLSymmetricPrivateKey key];
    NSData *encodedprivateKey = [NSKeyedArchiver archivedDataWithRootObject:privateKey];
    NACLSymmetricPrivateKey *decodedPrivateKey = [NSKeyedUnarchiver unarchiveObjectWithData:encodedprivateKey];
    
    XCTAssertTrue([privateKey isEqualToKey:decodedPrivateKey], @"");
}

@end
