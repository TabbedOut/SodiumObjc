//
//  NACLAsymmetricKeyPair.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLAsymmetricKeyPair.h"
#import "NACL.h"

@interface NACLAsymmetricKeyPair ()
@property (strong, nonatomic, readwrite) NACLAsymmetricPublicKey *publicKey;
@property (strong, nonatomic, readwrite) NACLAsymmetricPrivateKey *privateKey;
@end

@implementation NACLAsymmetricKeyPair

+ (void)initialize 
{
	[NACL initializeNACL];
	[super initialize];
}

+ (instancetype)keyPair
{
    NACLAsymmetricKeyPair *__autoreleasing keyPair = [[self alloc] init];
    return keyPair;
}

+ (instancetype)keyPairWithSeed:(NSData *)seed
{
    NACLAsymmetricKeyPair *__autoreleasing keyPair = [[self alloc] initWithSeed:seed];
    return keyPair;
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
            _privateKey = [[NACLAsymmetricPrivateKey alloc] initWithData:keyData];
        }
        
        if (publicKey) {
            NSData *keyData = [NSData dataWithBytes:publicKey length:crypto_box_PUBLICKEYBYTES];
            _publicKey = [[NACLAsymmetricPublicKey alloc] initWithData:keyData];
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
    NACLAsymmetricKeyPair *copy = [[self class] alloc];
    
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

- (BOOL)isEqualToKeyPair:(NACLAsymmetricKeyPair *)keyPair
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
