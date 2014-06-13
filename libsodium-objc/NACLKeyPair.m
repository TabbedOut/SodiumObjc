//
//  NACLKeyPair.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/11/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLKeyPair.h"
#import "NACL.h"

@interface NACLKeyPair ()
@property (strong, nonatomic, readwrite) NSData *secretKey;
@property (strong, nonatomic, readwrite) NSData *publicKey;
@end

@implementation NACLKeyPair

+ (void)initialize 
{
	[NACL initializeNACL];
	[super initialize];
}

+ (instancetype)keyPair
{
    NACLKeyPair *__autoreleasing keyPair = [[self alloc] init];
    return keyPair;
}

+ (instancetype)keyPairWithSeed:(NSData *)seed
{
    NACLKeyPair *__autoreleasing keyPair = [[self alloc] initWithSeed:seed];
    return keyPair;
}

- (instancetype)init
{
    return [self initWithSeed:nil];
}

- (instancetype)initWithSeed:(NSData *)seed
{
    self = [super init];
    
    if (self) {
        [self generateKeyPairWithSeed:seed];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    if (self) {
        _secretKey = [[coder decodeObject] copy];
        _publicKey = [[coder decodeObject] copy];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_secretKey];
    [coder encodeObject:_publicKey];
}

- (void)generateKeyPairWithSeed:(NSData *)seed
{
    NSAssert(false, @"generateKeyPairWithSeed is to be implemented in a subclass of NACLKeyPair");
}

- (id)copyWithZone:(NSZone *)zone
{
    NACLKeyPair *copy = [[self class] alloc];
    
    copy.publicKey = [_publicKey copy];
    copy.secretKey = [_secretKey copy];
    
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

- (BOOL)isEqualToKeyPair:(NACLKeyPair *)keyPair
{
    if (self == keyPair) {
        return YES;
    }
    
    BOOL equal = YES;
    
    equal &= [_publicKey isEqualToData:keyPair.publicKey];
    equal &= [_secretKey isEqualToData:keyPair.secretKey];
    
    return equal;
}

- (NSUInteger)hash
{
    NSUInteger hash = 1;
    
    hash = 31 * hash + [_publicKey hash];
    hash = 31 * hash + [_secretKey hash];
    
    return hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ {publicKey: %@, secretKey: %@}", 
            NSStringFromClass([self class]), _publicKey, _secretKey];
}

@end
