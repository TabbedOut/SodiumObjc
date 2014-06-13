//
//  NACLSigningKeyPair.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACL.h"
#import "NACLKeySubclass.h"
#import "NACLSigningKeyPair.h"

@interface NACLKeyPair (Private)
@property (strong, nonatomic, readwrite) NSData *secretKey;
@property (strong, nonatomic, readwrite) NSData *publicKey;

- (void)generateKeyPairWithSeed:(NSData *)seed;

@end

@implementation NACLSigningKeyPair

- (void)generateKeyPairWithSeed:(NSData *)seed
{
    unsigned char secretKey[crypto_sign_SECRETKEYBYTES];
	unsigned char publicKey[crypto_sign_PUBLICKEYBYTES];
    
    if ([seed length] > 0) {
        crypto_sign_seed_keypair(publicKey, secretKey, seed.bytes);
    } else {
        crypto_sign_keypair(publicKey, secretKey);
    }
    
    if (secretKey) {
        super.secretKey = [[NSData alloc] initWithBytes:secretKey length:crypto_sign_SECRETKEYBYTES];
    }
    
    if (publicKey) {
        super.publicKey = [[NSData alloc] initWithBytes:publicKey length:crypto_sign_PUBLICKEYBYTES];
    }
}

@end
