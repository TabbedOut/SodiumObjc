//
//  NACLAsymmetricKeyPair.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <sodium.h>
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
    return 0;
}

- (instancetype)init
{
    return [self initWithSeed:nil];
}

- (instancetype)initWithSeed:(NSData *)seed
{
    self = [super init];
    
    if (self) {
        unsigned char privateKey[crypto_box_SECRETKEYBYTES];
        unsigned char publicKey[crypto_box_PUBLICKEYBYTES];
        
        crypto_box_keypair(publicKey, privateKey);
        
        if (privateKey) {
            NSData *keyData = [NSData dataWithBytes:privateKey length:crypto_box_SECRETKEYBYTES];
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

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self) {
        self.privateKey = [decoder decodeObjectOfClass:[NACLAsymmetricPrivateKey class] forKey:NACLKeyPairPrivateKeyCodingKey];
        self.publicKey = [decoder decodeObjectOfClass:[NACLAsymmetricPublicKey class] forKey:NACLKeyPairPublicKeyCodingKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.privateKey forKey:NACLKeyPairPrivateKeyCodingKey];
    [encoder encodeObject:self.publicKey forKey:NACLKeyPairPublicKeyCodingKey];
}

@end
