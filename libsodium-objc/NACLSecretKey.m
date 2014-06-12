//
//  NACLSecretKey.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLSecretKey.h"
#import "NACL.h"

const size_t NACLSecretKeyByteCount = crypto_secretbox_KEYBYTES;

@interface NACLSecretKey ()
@property (copy, nonatomic, readwrite) NSData *data;
@end

@implementation NACLSecretKey

+ (instancetype)secretKey
{
    NACLSecretKey *__autoreleasing secretKey = [[NACLSecretKey alloc] init];
    return secretKey;
}

+ (instancetype)secretKeyWithData:(NSData *)keyData
{
    NACLSecretKey *__autoreleasing secretKey = [[NACLSecretKey alloc] initWithData:keyData];
    return secretKey;
}

- (instancetype)init
{
    unsigned char *keyDataBuffer = calloc(NACLSecretKeyByteCount, sizeof(unsigned char));
    randombytes_buf(keyDataBuffer, NACLSecretKeyByteCount);
    
    NSData *keyData = [[NSData alloc] initWithBytes:keyDataBuffer length:NACLSecretKeyByteCount];
    
    return [self initWithData:keyData];
}

- (instancetype)initWithData:(NSData *)keyData
{
    NSParameterAssert([keyData length] == NACLSecretKeyByteCount);
    
    self = [super init];
    
    if (self) {
        _data = [keyData copy];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    
    if (self) {
        _data = [[coder decodeObject] copy];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_data];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[NACLSecretKey alloc] initWithData:_data];
}

- (BOOL)isEqual:(id)object
{
    if (object == nil) {
        return NO;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToSecretKey:object];
}

- (BOOL)isEqualToSecretKey:(NACLSecretKey *)secretKey
{
    if (self == secretKey) {
        return YES;
    }
    
    BOOL equal = [_data isEqualToData:secretKey.data];
    
    return equal;
}

- (NSUInteger)hash
{
    NSUInteger hash = 1;
    
    hash = 31 * hash + [_data hash];
    
    return hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ {keyData: %@}", NSStringFromClass([self class]), _data];
}

@end
