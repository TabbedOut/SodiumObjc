//
//  NACLSigningKeyPair.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <sodium.h>
#import <SodiumObjc/NACL.h>
#import <SodiumObjc/NACLKeyPairSubclass.h>
#import <SodiumObjc/NACLSigningKeyPair.h>

@implementation NACLSigningKeyPair

+ (void)initialize 
{
	[NACL initializeNACL];
	[super initialize];
}

+ (NSUInteger)seedLength
{
    return crypto_sign_SEEDBYTES;
}

- (instancetype)init
{
    return [self initWithSeed:nil];
}

- (instancetype)initWithSeed:(NSData *)seed
{
    self = [super init];
    
    if (self) {
        unsigned char privateKey[crypto_sign_SECRETKEYBYTES];
        unsigned char publicKey[crypto_sign_PUBLICKEYBYTES];
        
        if ([seed length] > 0) {
            NSParameterAssert(seed.length == crypto_sign_SEEDBYTES);
            crypto_sign_seed_keypair(publicKey, privateKey, seed.bytes);
        } else {
            crypto_sign_keypair(publicKey, privateKey);
        }
        
        if (privateKey) {
            NSData *keyData = [NSData dataWithBytes:privateKey length:crypto_sign_SECRETKEYBYTES];
            self.privateKey = [NACLSigningPrivateKey keyWithData:keyData];
        }
        
        if (publicKey) {
            NSData *keyData = [NSData dataWithBytes:publicKey length:crypto_sign_PUBLICKEYBYTES];
            self.publicKey = [NACLSigningPublicKey keyWithData:keyData];
        }
    }
    
    return self;
}

- (BOOL)isEqualToKeyPair:(NACLSigningKeyPair *)keyPair
{
    return [super isEqualToKeyPair:keyPair];
}

@end
