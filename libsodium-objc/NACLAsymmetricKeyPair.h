//
//  NACLAsymmetricKeyPair.h
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLAsymetricPublicKey.h"
#import "NACLAsymetricPrivateKey.h"

/**
 *  A key pair that is to be used for public key cryptography operations.
 */
@interface NACLAsymmetricKeyPair : NSObject <NSCopying, NSCoding>
@property (strong, nonatomic, readonly) NACLAsymetricPublicKey *publicKey;
@property (strong, nonatomic, readonly) NACLAsymetricPrivateKey *privateKey;

+ (instancetype)keyPair;
+ (instancetype)keyPairWithSeed:(NSData *)seed;
- (instancetype)initWithSeed:(NSData *)seed;
- (BOOL)isEqualToAssymetricKeyPair:(NACLAsymmetricKeyPair *)keyPair;

@end
