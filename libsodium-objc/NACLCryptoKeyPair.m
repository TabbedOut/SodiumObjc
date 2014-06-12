//
//  NACLCryptoKeyPair.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLCryptoKeyPair.h"
#import "NACL.h"

@interface NACLKeyPair (Private)
@property (strong, nonatomic, readwrite) NSData *secretKey;
@property (strong, nonatomic, readwrite) NSData *publicKey;

- (void)generateKeyPairWithSeed:(NSData *)seed;

@end

@implementation NACLCryptoKeyPair

- (void)generateKeyPairWithSeed:(NSData *)seed
{
	unsigned char secretKey[crypto_box_SECRETKEYBYTES];
	unsigned char publicKey[crypto_box_PUBLICKEYBYTES];
    
    if ([seed length] > 0) {
        crypto_box_seed_keypair(publicKey, secretKey, seed.bytes);
    } else {
        crypto_box_keypair(publicKey, secretKey);
    }
    
    if (secretKey) {
        super.secretKey = [[NSData alloc] initWithBytes:secretKey length:crypto_box_SECRETKEYBYTES];
    }
    
    if (publicKey) {
        super.publicKey = [[NSData alloc] initWithBytes:publicKey length:crypto_box_PUBLICKEYBYTES];
    }
}

@end
