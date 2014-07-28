//
//  NACLKeyPairTests.m
//  SodiumObjc
//
//  Created by Damian Carrillo on 7/28/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NACLKeyPair.h"

@interface NACLKeyPair (Testing)

- (NSUInteger)seedLength;

@end

@interface NACLKeyPairTests : XCTestCase

@end

@implementation NACLKeyPairTests

- (void)testSeedLength
{
    XCTAssertEqual([NACLKeyPair seedLength], 0, @"");
}

- (void)testSupportsSecureCoding
{
    XCTAssertTrue([NACLKeyPair supportsSecureCoding], @"");
}

- (void)testInitWithSeed_expectNil
{
    // Expect nil because this class is abstract. Initialize a subclass instead.
    
    NACLKeyPair *keyPair = [[NACLKeyPair alloc] initWithSeed:[NSData data]];
    
    XCTAssertNil(keyPair, @"");
}

@end
