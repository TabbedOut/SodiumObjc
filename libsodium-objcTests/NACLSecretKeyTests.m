//
//  NACLSecretKeyTests.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NACLSecretKey.h"

@interface NACLSecretKeyTests : XCTestCase
@end

@implementation NACLSecretKeyTests

- (void)assertSecretKeyIsValid:(NACLSecretKey *)secretKey
{
    XCTAssertNotNil(secretKey, @"");
    XCTAssertNotNil(secretKey.data, @"");
    XCTAssertEqual(secretKey.data.length, NACLSecretKeyByteCount, @"");
}

- (void)testInit
{
    NACLSecretKey *secretKey = [[NACLSecretKey alloc] init];
    
    [self assertSecretKeyIsValid:secretKey];
}

- (void)testInitWithData_withValidData
{   
    NSMutableData *data = [NSMutableData dataWithLength:NACLSecretKeyByteCount];
    [[NSInputStream inputStreamWithFileAtPath:@"/dev/urandom"] read:(uint8_t *) [data mutableBytes] maxLength:NACLSecretKeyByteCount];
    
    NACLSecretKey *secretKey = [[NACLSecretKey alloc] initWithData:data];
    
    [self assertSecretKeyIsValid:secretKey];
}

- (void)testSecretKey
{
    NACLSecretKey *secretKey = [NACLSecretKey secretKey];
    
    [self assertSecretKeyIsValid:secretKey];
}

- (void)testSecretKeyWithData
{
    NSMutableData *data = [NSMutableData dataWithLength:NACLSecretKeyByteCount];
    [[NSInputStream inputStreamWithFileAtPath:@"/dev/urandom"] read:(uint8_t *) [data mutableBytes] maxLength:NACLSecretKeyByteCount];
    
    NACLSecretKey *secretKey = [NACLSecretKey secretKeyWithData:data];
    
    [self assertSecretKeyIsValid:secretKey];
}

- (void)testCopy
{
    NACLSecretKey *secretKey = [NACLSecretKey secretKey];
    NACLSecretKey *copy = [secretKey copy];
    
    XCTAssertNotNil(copy, @"");
    XCTAssertNotEqual(secretKey, copy, @"");
    XCTAssertEqualObjects(secretKey.data, copy.data, @"");
}

- (void)testIsEqual_whenSame
{
    NACLSecretKey *secretKey = [NACLSecretKey secretKey];
    NACLSecretKey *same = secretKey;
    
    XCTAssertTrue([secretKey isEqual:same], @"");
    XCTAssertTrue([same isEqual:secretKey], @"");
}

- (void)testIsEqual_whenEqual
{
    NACLSecretKey *secretKey = [NACLSecretKey secretKey];
    NACLSecretKey *copy = [secretKey copy];
    
    XCTAssertTrue([secretKey isEqual:copy], @"");
    XCTAssertTrue([copy isEqual:secretKey], @"");
}

- (void)testIsEqual_whenNotEqual
{
    NACLSecretKey *secretKeyA = [NACLSecretKey secretKey];
    NACLSecretKey *secretKeyB = [NACLSecretKey secretKey];
    
    XCTAssertFalse([secretKeyA isEqual:secretKeyB], @"");
    XCTAssertFalse([secretKeyB isEqual:secretKeyA], @"");
}

- (void)testIsEqual_withNil
{
    NACLSecretKey *secretKeyA = [NACLSecretKey secretKey];
    
    XCTAssertFalse([secretKeyA isEqual:nil], @"");    
}

- (void)testIsEqualToSecretKey_whenSame
{
    NACLSecretKey *secretKey = [NACLSecretKey secretKey];
    NACLSecretKey *same = secretKey;
    
    XCTAssertTrue([secretKey isEqualToSecretKey:same], @"");
    XCTAssertTrue([same isEqualToSecretKey:secretKey], @"");
}

- (void)testIsEqualToSecretKey_whenEqual
{
    NACLSecretKey *secretKey = [NACLSecretKey secretKey];
    NACLSecretKey *copy = [secretKey copy];
    
    XCTAssertTrue([secretKey isEqualToSecretKey:copy], @"");
    XCTAssertTrue([copy isEqualToSecretKey:secretKey], @"");
}

- (void)testIsEqualToSecretKey_whenNotEqual
{
    NACLSecretKey *secretKeyA = [NACLSecretKey secretKey];
    NACLSecretKey *secretKeyB = [NACLSecretKey secretKey];
    
    XCTAssertFalse([secretKeyA isEqualToSecretKey:secretKeyB], @"");
    XCTAssertFalse([secretKeyB isEqualToSecretKey:secretKeyA], @"");
}

- (void)testIsEqualToSecretKey_withNil
{
    NACLSecretKey *secretKeyA = [NACLSecretKey secretKey];
    
    XCTAssertFalse([secretKeyA isEqualToSecretKey:nil], @"");
}

- (void)testHash
{
    NACLSecretKey *secretKeyA = [NACLSecretKey secretKey];
    NACLSecretKey *copy = [secretKeyA copy];
    
    XCTAssertEqual(secretKeyA.hash, copy.hash, @"");
}

- (void)testArchival
{
    NACLSecretKey *secretKey = [NACLSecretKey secretKey];    
    NSData *encodedSecretKey = [NSKeyedArchiver archivedDataWithRootObject:secretKey];
    
    XCTAssertTrue(encodedSecretKey.length > 0, @"");
}

- (void)testUnarchival
{
    NACLSecretKey *secretKey = [NACLSecretKey secretKey];
    NSData *encodedSecretKey = [NSKeyedArchiver archivedDataWithRootObject:secretKey];
    NACLSecretKey *decodedSecretKey = [NSKeyedUnarchiver unarchiveObjectWithData:encodedSecretKey];
    
    XCTAssertTrue([secretKey isEqualToSecretKey:decodedSecretKey], @"");
}

@end
