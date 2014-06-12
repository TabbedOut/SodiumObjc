//
//  NACLNonce.m
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLNonce.h"
#import "NACL.h"
#import "sodium.h"

const size_t NACLNonceByteCount = crypto_box_NONCEBYTES;

@interface NACLNonce ()
@property (strong, nonatomic, readwrite) NSData *data;
@end

@implementation NACLNonce

+ (void)initialize 
{
	[NACL initializeNACL];
	[super initialize];
}

+ (instancetype)nonce
{
    return [self nonceFromRandomBytes];
}

+ (instancetype)nonceFromRandomBytes
{
    NACLNonce *__autoreleasing nonce = [[NACLNonce alloc] initWithRandomBytes];
    return nonce;
}

+ (instancetype)nonceFromTimestamp
{
    NACLNonce *__autoreleasing nonce = [[NACLNonce alloc] initWithTimestamp];
    return nonce;    
}

+ (instancetype)nonceWithData:(NSData *)nonceData
{
    NACLNonce *__autoreleasing nonce = [[NACLNonce alloc] initWithData:nonceData];
    return nonce;
}

- (instancetype)init
{
    return [self initWithRandomBytes];
}

- (instancetype)initWithRandomBytes
{
	unsigned char noncebuf[NACLNonceByteCount];
	randombytes_buf(noncebuf, NACLNonceByteCount);
    
    NSData *nonceData = [NSData dataWithBytes:noncebuf length:NACLNonceByteCount];
	
    return [self initWithData:nonceData];
}

- (instancetype)initWithTimestamp 
{
	unsigned char noncebuf[NACLNonceByteCount];
	randombytes_buf(noncebuf, NACLNonceByteCount);
    
	time_t currTime = time(NULL);
	memcpy(noncebuf, &currTime, MIN(sizeof(time_t), NACLNonceByteCount / 2));
    
    NSData *nonceData = [NSData dataWithBytes:noncebuf length:NACLNonceByteCount];
    
    return [self initWithData:nonceData];
}

- (instancetype)initWithData:(NSData *)nonceData
{
    NSParameterAssert(nonceData.length == NACLNonceByteCount);
    
    self = [super init];
    
    if (self) {
        _data = [nonceData copy];
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
    return [[NACLNonce alloc] initWithData:_data];
}

- (BOOL)isEqual:(id)object
{
    if (object == nil) {
        return NO;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToNonce:object];
}

- (BOOL)isEqualToNonce:(NACLNonce *)nonce
{
    if (self == nonce) {
        return YES;
    }
    
    BOOL equal = [_data isEqualToData:nonce.data];
    
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
    return [NSString stringWithFormat:@"%@ {nonceData: %@}", NSStringFromClass([self class]), _data];
}

@end
