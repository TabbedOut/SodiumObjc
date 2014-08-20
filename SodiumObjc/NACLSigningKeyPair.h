//
//  NACLSigningKeyPair.h
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLKeyPair.h"
#import "NACLSigningPublicKey.h"
#import "NACLSigningPrivateKey.h"

/**
 *  A key pair that is to be used in signing operations.
 */
@interface NACLSigningKeyPair : NACLKeyPair
@property (strong, nonatomic, readonly) NACLSigningPublicKey *publicKey;
@property (strong, nonatomic, readonly) NACLSigningPrivateKey *privateKey;

/**
 *  Indicates whether or not the receiver is equal to the given key pair. 
 *  Equality is determined by `publicKeyData` and `privateKeyData` being 
 *  equal for both the receiver and the given key pair.
 *  
 *  @param keyPair The key pair to test for equalitys.
 *  @return Whether or not the receiver is equal to the given key pair.
 */
- (BOOL)isEqualToKeyPair:(NACLSigningKeyPair *)keyPair;

@end
