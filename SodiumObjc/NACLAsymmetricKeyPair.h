//
//  NACLAsymmetricKeyPair.h
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLAsymmetricPublicKey.h"
#import "NACLAsymmetricPrivateKey.h"
#import "NACLKeyPair.h"

/**
 *  A key pair that is to be used for public key cryptography operations.
 */
@interface NACLAsymmetricKeyPair : NACLKeyPair
@property (strong, nonatomic, readonly) NACLAsymmetricPublicKey *publicKey;
@property (strong, nonatomic, readonly) NACLAsymmetricPrivateKey *privateKey;

- (BOOL)isEqualToKeyPair:(NACLAsymmetricKeyPair *)keyPair;

@end
