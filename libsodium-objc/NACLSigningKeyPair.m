//
//  NACLSigningKeyPair.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACL.h"
#import "NACLSigningKeyPair.h"

@interface NACLSigningKeyPair ()
@property (strong, nonatomic, readwrite) NACLSigningPublicKey *publicKey;
@property (strong, nonatomic, readwrite) NACLSigningPrivateKey *privateKey;

@end

@implementation NACLSigningKeyPair

+ (void)initialize 
{
	[NACL initializeNACL];
	[super initialize];
}

+ (instancetype)keyPair
{
    NACLSigningKeyPair *__autoreleasing keyPair = [[self alloc] init];
    return keyPair;
}

+ (instancetype)keyPairWithSeed:(NSData *)seed
{
    NACLSigningKeyPair *__autoreleasing keyPair = [[self alloc] initWithSeed:seed];
    return keyPair;
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
        unsigned char secretKey[crypto_sign_SECRETKEYBYTES];
        unsigned char publicKey[crypto_sign_PUBLICKEYBYTES];
        
        if ([seed length] > 0) {
            NSParameterAssert(seed.length == crypto_sign_SEEDBYTES);
            crypto_sign_seed_keypair(publicKey, secretKey, seed.bytes);
        } else {
            crypto_sign_keypair(publicKey, secretKey);
        }
        
        if (secretKey) {
            NSData *keyData = [NSData dataWithBytes:secretKey length:crypto_sign_SECRETKEYBYTES];
            _privateKey = [NACLSigningPrivateKey keyWithData:keyData];
        }
        
        if (publicKey) {
            NSData *keyData = [NSData dataWithBytes:publicKey length:crypto_sign_PUBLICKEYBYTES];
            _publicKey = [NACLSigningPublicKey keyWithData:keyData];
        }
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    if (self) {
        _privateKey = [[coder decodeObject] copy];
        _publicKey = [[coder decodeObject] copy];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_privateKey];
    [coder encodeObject:_publicKey];
}

- (id)copyWithZone:(NSZone *)zone
{
    NACLSigningKeyPair *copy = [[self class] alloc];
    
    copy.publicKey = [_publicKey copy];
    copy.privateKey = [_privateKey copy];
    
    return copy;
}

- (BOOL)isEqual:(id)object
{
    if (object == nil) {
        return NO;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToKeyPair:object];
}

- (BOOL)isEqualToKeyPair:(NACLSigningKeyPair *)keyPair
{
    if (self == keyPair) {
        return YES;
    }
    
    BOOL equal = YES;
    
    equal &= [_publicKey isEqualToKey:keyPair.publicKey];
    equal &= [_privateKey isEqualToKey:keyPair.privateKey];
    
    return equal;
}

- (NSUInteger)hash
{
    NSUInteger hash = 1;
    
    hash = 31 * hash + [_publicKey hash];
    hash = 31 * hash + [_privateKey hash];
    
    return hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ {publicKey: %@, privateKey: %@}", 
            NSStringFromClass([self class]), _publicKey, _privateKey];
}

@end
