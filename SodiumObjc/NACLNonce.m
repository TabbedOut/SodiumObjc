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

static NSString *const NACLDataCodingKey = @"NACLDataCodingKey";

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

+ (NSUInteger)nonceLength
{
    return crypto_box_NONCEBYTES;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)init
{
    return [self initWithRandomBytes];
}

- (instancetype)initWithRandomBytes
{
    NSUInteger nonceLength = [[self class] nonceLength];
	unsigned char noncebuf[nonceLength];
	randombytes_buf(noncebuf, nonceLength);
    
    NSData *nonceData = [NSData dataWithBytes:noncebuf length:nonceLength];
	
    return [self initWithData:nonceData];
}

- (instancetype)initWithTimestamp 
{
    NSUInteger nonceLength = [NACLNonce nonceLength];
	unsigned char noncebuf[nonceLength];
	randombytes_buf(noncebuf, nonceLength);
    
	time_t currTime = time(NULL);
	memcpy(noncebuf, &currTime, MIN(sizeof(time_t), nonceLength / 2));
    
    NSData *nonceData = [NSData dataWithBytes:noncebuf length:nonceLength];
    
    return [self initWithData:nonceData];
}

- (instancetype)initWithData:(NSData *)nonceData
{
    NSParameterAssert(nonceData.length == [[self class] nonceLength]);
    
    self = [super init];
    
    if (self) {
        _data = [nonceData copy];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self) {
        _data = [decoder decodeObjectOfClass:[NSData class] forKey:NACLDataCodingKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_data forKey:NACLDataCodingKey];
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
