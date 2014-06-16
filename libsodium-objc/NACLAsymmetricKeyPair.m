//
//  NACLAsymmetricKeyPair.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLAsymmetricKeyPair.h"
#import "NACL.h"
#import "NACLKeyPairSubclass.h"

@implementation NACLAsymmetricKeyPair

+ (void)initialize 
{
	[NACL initializeNACL];
	[super initialize];
}

+ (NSUInteger)seedLength
{
    return crypto_box_SEEDBYTES;
}

- (instancetype)init
{
    return [self initWithSeed:nil];
}

- (instancetype)initWithSeed:(NSData *)seed
{
    self = [super init];
    
    if (self) {
        unsigned char secretKey[crypto_box_SECRETKEYBYTES];
        unsigned char publicKey[crypto_box_PUBLICKEYBYTES];
        
        if ([seed length] > 0) {
            NSParameterAssert(seed.length == crypto_box_SEEDBYTES);
            crypto_box_seed_keypair(publicKey, secretKey, seed.bytes);
        } else {
            crypto_box_keypair(publicKey, secretKey);
        }
        
        if (secretKey) {
            NSData *keyData = [NSData dataWithBytes:secretKey length:crypto_box_SECRETKEYBYTES];
            self.privateKey = [[NACLAsymmetricPrivateKey alloc] initWithData:keyData];
        }
        
        if (publicKey) {
            NSData *keyData = [NSData dataWithBytes:publicKey length:crypto_box_PUBLICKEYBYTES];
            self.publicKey = [[NACLAsymmetricPublicKey alloc] initWithData:keyData];
        }
    }
    
    return self;
}

- (BOOL)isEqualToKeyPair:(NACLAsymmetricKeyPair *)keyPair
{
    return [super isEqualToKeyPair:keyPair];
}

@end
