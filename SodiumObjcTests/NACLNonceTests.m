//
//  NACLNonceTests.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/11/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NACLNonce.h"

@interface NACLNonceTests : XCTestCase
@end

@implementation NACLNonceTests

- (void)assertNonceIsValid:(NACLNonce *)nonce
{
    XCTAssertNotNil(nonce, @"");
    XCTAssertTrue([nonce.data length] == [NACLNonce nonceLength], @"");
}

- (void)testInit
{
    NACLNonce *nonce = [[NACLNonce alloc] init];
    
    [self assertNonceIsValid:nonce];
}

- (void)testInitWithRandomBytes
{
    NACLNonce *nonce = [[NACLNonce alloc] initWithRandomBytes];
    
    [self assertNonceIsValid:nonce];
}

- (void)testInitWithTimestamp
{
    NACLNonce *nonce = [[NACLNonce alloc] initWithTimestamp];
    
    [self assertNonceIsValid:nonce];
}

- (void)testInitWithData
{
    NSData *data = [@"i-am-a-nonce-i-am-a-nonce-i-am-a-nonce" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSRange range = {0, [NACLNonce nonceLength]};
    data = [data subdataWithRange:range];
    
    NACLNonce *nonce = [[NACLNonce alloc] initWithData:data];
    
    [self assertNonceIsValid:nonce];
}

- (void)testCreation
{
    NACLNonce *nonce = [NACLNonce nonce];
    
    [self assertNonceIsValid:nonce];
}

- (void)testCreateFromRandomBytes
{
    NACLNonce *nonce = [NACLNonce nonceFromRandomBytes];
    
    [self assertNonceIsValid:nonce];
}

- (void)testCreateFromTimestamp
{
    NACLNonce *nonce = [NACLNonce nonceFromTimestamp];
    
    [self assertNonceIsValid:nonce];
}

- (void)testCreateWithBytes
{
    NSData *data = [@"i-am-a-nonce-i-am-a-nonce-i-am-a-nonce" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSRange range = {0, [NACLNonce nonceLength]};
    data = [data subdataWithRange:range];
    
    NACLNonce *nonce = [NACLNonce nonceWithData:data];
    
    [self assertNonceIsValid:nonce];
}

- (void)testCopy
{
    NACLNonce *nonce = [NACLNonce nonce];
    NACLNonce *copy = [nonce copy];
    
    XCTAssertNotNil(copy, @"");
    XCTAssertNotEqual(nonce, copy, @"");
    XCTAssertEqualObjects(nonce.data, copy.data, @"");
}

- (void)testIsEqual_whenSame
{
    NACLNonce *nonce = [NACLNonce nonce];
    NACLNonce *same = nonce;
    
    XCTAssertTrue([nonce isEqual:same], @"");
    XCTAssertTrue([same isEqual:nonce], @"");
}

- (void)testIsEqual_whenEqual
{
    NACLNonce *nonce = [NACLNonce nonce];
    NACLNonce *copy = [nonce copy];
    
    XCTAssertTrue([nonce isEqual:copy], @"");
    XCTAssertTrue([copy isEqual:nonce], @"");
}

- (void)testIsEqual_whenNotEqual
{
    NACLNonce *nonceA = [NACLNonce nonce];
    NACLNonce *nonceB = [NACLNonce nonce];
    
    XCTAssertFalse([nonceA isEqual:nonceB], @"");
    XCTAssertFalse([nonceB isEqual:nonceA], @"");
}

- (void)testIsEqual_withNil
{
    NACLNonce *nonceA = [NACLNonce nonce];
    
    XCTAssertFalse([nonceA isEqual:nil], @"");    
}

- (void)testIsEqualToNonce_whenSame
{
    NACLNonce *nonce = [NACLNonce nonce];
    NACLNonce *same = nonce;
    
    XCTAssertTrue([nonce isEqualToNonce:same], @"");
    XCTAssertTrue([same isEqualToNonce:nonce], @"");
}

- (void)testIsEqualToNonce_whenEqual
{
    NACLNonce *nonce = [NACLNonce nonce];
    NACLNonce *copy = [nonce copy];
    
    XCTAssertTrue([nonce isEqualToNonce:copy], @"");
    XCTAssertTrue([copy isEqualToNonce:nonce], @"");
}

- (void)testIsEqualToNonce_whenNotEqual
{
    NACLNonce *nonceA = [NACLNonce nonce];
    NACLNonce *nonceB = [NACLNonce nonce];
    
    XCTAssertFalse([nonceA isEqualToNonce:nonceB], @"");
    XCTAssertFalse([nonceB isEqualToNonce:nonceA], @"");
}

- (void)testIsEqual_withDifferentClass
{
    NACLNonce *nonce = [NACLNonce nonce];
    
    XCTAssertFalse([nonce isEqual:@"something"], @"");
}

- (void)testisEqualToNonce_withNil
{
    NACLNonce *nonceA = [NACLNonce nonce];
    
    XCTAssertFalse([nonceA isEqualToNonce:nil], @"");
}

- (void)testHash
{
    NACLNonce *nonceA = [NACLNonce nonce];
    NACLNonce *copy = [nonceA copy];
    
    XCTAssertEqual(nonceA.hash, copy.hash, @"");
}

- (void)testArchival
{
    NACLNonce *nonce = [NACLNonce nonce];    
    NSData *encodednonce = [NSKeyedArchiver archivedDataWithRootObject:nonce];
    
    XCTAssertTrue(encodednonce.length > 0, @"");
}

- (void)testUnarchival
{
    NACLNonce *nonce = [NACLNonce nonce];
    NSData *encodednonce = [NSKeyedArchiver archivedDataWithRootObject:nonce];
    NACLNonce *decodednonce = [NSKeyedUnarchiver unarchiveObjectWithData:encodednonce];
    
    XCTAssertTrue([nonce isEqualToNonce:decodednonce], @"");
}

- (void)testSupportsSecureCoding
{
    XCTAssertTrue([NACLNonce supportsSecureCoding], @"");
}

- (void)testDescription
{
    NACLNonce *nonce = [NACLNonce nonce];
    
    XCTAssertTrue([[nonce description] length] > 0, @"");
}

@end
