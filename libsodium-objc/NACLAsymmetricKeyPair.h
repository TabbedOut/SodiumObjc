//
//  NACLAsymmetricKeyPair.h
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLPublicKey.h"
#import "NACLPrivateKey.h"

/**
 *  A key pair that is to be used for public key cryptography operations.
 */
@interface NACLAsymmetricKeyPair : NSObject <NSCopying, NSCoding>
@property (strong, nonatomic, readonly) NACLPublicKey *publicKey;
@property (strong, nonatomic, readonly) NACLPrivateKey *privateKey;

+ (instancetype)keyPair;
+ (instancetype)keyPairWithSeed:(NSData *)seed;
- (instancetype)initWithSeed:(NSData *)seed;
- (BOOL)isEqualToAssymetricKeyPair:(NACLAsymmetricKeyPair *)keyPair;

@end
