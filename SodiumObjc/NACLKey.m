//
//  NACLKey.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLKey.h"

static NSString *const NACLDataCodingKey = @"NACLDataCodingKey";

@interface NACLKey ()
@property (copy, nonatomic, readwrite) NSData *data;
@end

@implementation NACLKey

+ (instancetype)key
{
    NACLKey *__autoreleasing key = [[[self class] alloc] init];
    return key;
}

+ (instancetype)keyWithData:(NSData *)keyData
{
    NACLKey *__autoreleasing key = [[[self class] alloc] initWithData:keyData];
    return key;
}

+ (NSUInteger)keyLength
{
    return 0;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)init
{
    return [self initWithData:[self generateDefaultKeyData]];
}

- (instancetype)initWithData:(NSData *)keyData
{
    self = [super init];
    
    if (self) {
        _data = [keyData copy];
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
    return [[[self class] alloc] initWithData:_data];
}

- (BOOL)isEqual:(id)object
{
    if (object == nil) {
        return NO;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToKey:object];
}

- (BOOL)isEqualToKey:(NACLKey *)key
{
    return [_data isEqualToData:key.data];
}

- (NSUInteger)hash
{
    NSUInteger hash = 1;
    
    hash = 31 * hash + [_data hash];
    
    return hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ {data: %@}", NSStringFromClass([self class]), _data];
}

- (NSData *)generateDefaultKeyData
{
    NSAssert(NO, @"Implement me in a subclass");
    
    return nil;
}

@end
