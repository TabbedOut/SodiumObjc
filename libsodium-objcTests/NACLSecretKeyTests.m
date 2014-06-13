//
//  NACLSecretKeyTests.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NACLSymmetricSecretKey.h"

@interface NACLSecretKeyTests : XCTestCase
@end

@implementation NACLSecretKeyTests

- (void)assertSecretKeyIsValid:(NACLSymmetricSecretKey *)secretKey
{
    XCTAssertNotNil(secretKey, @"");
    XCTAssertNotNil(secretKey.data, @"");
    XCTAssertEqual(secretKey.data.length, NACLSecretKeyByteCount, @"");
}

- (void)testInit
{
    NACLSymmetricSecretKey *secretKey = [[NACLSymmetricSecretKey alloc] init];
    
    [self assertSecretKeyIsValid:secretKey];
}

- (void)testInitWithData_withValidData
{   
    NSMutableData *data = [NSMutableData dataWithLength:NACLSecretKeyByteCount];
    [[NSInputStream inputStreamWithFileAtPath:@"/dev/urandom"] read:(uint8_t *) [data mutableBytes] maxLength:NACLSecretKeyByteCount];
    
    NACLSymmetricSecretKey *secretKey = [[NACLSymmetricSecretKey alloc] initWithData:data];
    
    [self assertSecretKeyIsValid:secretKey];
}

- (void)testSecretKey
{
    NACLSymmetricSecretKey *secretKey = [NACLSymmetricSecretKey key];
    
    [self assertSecretKeyIsValid:secretKey];
}

- (void)testSecretKeyWithData
{
    NSMutableData *data = [NSMutableData dataWithLength:NACLSecretKeyByteCount];
    [[NSInputStream inputStreamWithFileAtPath:@"/dev/urandom"] read:(uint8_t *) [data mutableBytes] maxLength:NACLSecretKeyByteCount];
    
    NACLSymmetricSecretKey *secretKey = [NACLSymmetricSecretKey keyWithData:data];
    
    [self assertSecretKeyIsValid:secretKey];
}

- (void)testCopy
{
    NACLSymmetricSecretKey *secretKey = [NACLSymmetricSecretKey key];
    NACLSymmetricSecretKey *copy = [secretKey copy];
    
    XCTAssertNotNil(copy, @"");
    XCTAssertNotEqual(secretKey, copy, @"");
    XCTAssertEqualObjects(secretKey.data, copy.data, @"");
}

- (void)testIsEqual_whenSame
{
    NACLSymmetricSecretKey *secretKey = [NACLSymmetricSecretKey key];
    NACLSymmetricSecretKey *same = secretKey;
    
    XCTAssertTrue([secretKey isEqual:same], @"");
    XCTAssertTrue([same isEqual:secretKey], @"");
}

- (void)testIsEqual_whenEqual
{
    NACLSymmetricSecretKey *secretKey = [NACLSymmetricSecretKey key];
    NACLSymmetricSecretKey *copy = [secretKey copy];
    
    XCTAssertTrue([secretKey isEqual:copy], @"");
    XCTAssertTrue([copy isEqual:secretKey], @"");
}

- (void)testIsEqual_whenNotEqual
{
    NACLSymmetricSecretKey *secretKeyA = [NACLSymmetricSecretKey key];
    NACLSymmetricSecretKey *secretKeyB = [NACLSymmetricSecretKey key];
    
    XCTAssertFalse([secretKeyA isEqual:secretKeyB], @"");
    XCTAssertFalse([secretKeyB isEqual:secretKeyA], @"");
}

- (void)testIsEqual_withNil
{
    NACLSymmetricSecretKey *secretKeyA = [NACLSymmetricSecretKey key];
    
    XCTAssertFalse([secretKeyA isEqual:nil], @"");    
}

- (void)testIsEqualToSecretKey_whenSame
{
    NACLSymmetricSecretKey *secretKey = [NACLSymmetricSecretKey key];
    NACLSymmetricSecretKey *same = secretKey;
    
    XCTAssertTrue([secretKey isEqualToKey:same], @"");
    XCTAssertTrue([same isEqualToKey:secretKey], @"");
}

- (void)testIsEqualToSecretKey_whenEqual
{
    NACLSymmetricSecretKey *secretKey = [NACLSymmetricSecretKey key];
    NACLSymmetricSecretKey *copy = [secretKey copy];
    
    XCTAssertTrue([secretKey isEqualToKey:copy], @"");
    XCTAssertTrue([copy isEqualToKey:secretKey], @"");
}

- (void)testIsEqualToSecretKey_whenNotEqual
{
    NACLSymmetricSecretKey *secretKeyA = [NACLSymmetricSecretKey key];
    NACLSymmetricSecretKey *secretKeyB = [NACLSymmetricSecretKey key];
    
    XCTAssertFalse([secretKeyA isEqualToKey:secretKeyB], @"");
    XCTAssertFalse([secretKeyB isEqualToKey:secretKeyA], @"");
}

- (void)testIsEqualToSecretKey_withNil
{
    NACLSymmetricSecretKey *secretKeyA = [NACLSymmetricSecretKey key];
    
    XCTAssertFalse([secretKeyA isEqualToKey:nil], @"");
}

- (void)testHash
{
    NACLSymmetricSecretKey *secretKeyA = [NACLSymmetricSecretKey key];
    NACLSymmetricSecretKey *copy = [secretKeyA copy];
    
    XCTAssertEqual(secretKeyA.hash, copy.hash, @"");
}

- (void)testArchival
{
    NACLSymmetricSecretKey *secretKey = [NACLSymmetricSecretKey key];    
    NSData *encodedSecretKey = [NSKeyedArchiver archivedDataWithRootObject:secretKey];
    
    XCTAssertTrue(encodedSecretKey.length > 0, @"");
}

- (void)testUnarchival
{
    NACLSymmetricSecretKey *secretKey = [NACLSymmetricSecretKey key];
    NSData *encodedSecretKey = [NSKeyedArchiver archivedDataWithRootObject:secretKey];
    NACLSymmetricSecretKey *decodedSecretKey = [NSKeyedUnarchiver unarchiveObjectWithData:encodedSecretKey];
    
    XCTAssertTrue([secretKey isEqualToKey:decodedSecretKey], @"");
}

@end
