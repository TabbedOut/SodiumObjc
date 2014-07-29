//
//  NACLKeyPair.m
//  
//
//  Created by Damian Carrillo on 6/16/14.
//
//

#import "NACLKeyPair.h"

NSString *const NACLKeyPairPrivateKeyCodingKey = @"NACLKeyPairPrivateKeyCodingKey";
NSString *const NACLKeyPairPublicKeyCodingKey = @"NACLKeyPairPublicKeyCodingKey";

@interface NACLKeyPair ()
@property (strong, nonatomic, readwrite) NACLKey *publicKey;
@property (strong, nonatomic, readwrite) NACLKey *privateKey;
@end

@implementation NACLKeyPair

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

+ (NSUInteger)seedLength
{
    // Implement seedLength in a subclass

    return 0;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithSeed:(NSData *)seed
{
    // Implement initWithSeed in a subclass
    
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self) {
        _privateKey = [decoder decodeObjectOfClass:[NACLKey class] forKey:NACLKeyPairPrivateKeyCodingKey];
        _publicKey = [decoder decodeObjectOfClass:[NACLKey class] forKey:NACLKeyPairPublicKeyCodingKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.privateKey forKey:NACLKeyPairPrivateKeyCodingKey];
    [encoder encodeObject:self.publicKey forKey:NACLKeyPairPublicKeyCodingKey];
}

- (id)copyWithZone:(NSZone *)zone
{
    NACLKeyPair *copy = [[self class] alloc];
    
    copy.publicKey = [self.publicKey copy];
    copy.privateKey = [self.privateKey copy];
    
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
    
    equal &= [self.publicKey isEqualToKey:keyPair.publicKey];
    equal &= [self.privateKey isEqualToKey:keyPair.privateKey];
    
    return equal;
}

- (NSUInteger)hash
{
    NSUInteger hash = 1;
    
    hash = 31 * hash + [self.publicKey hash];
    hash = 31 * hash + [self.privateKey hash];
    
    return hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ {publicKey: %@, privateKey: %@}", 
            NSStringFromClass([self class]), self.publicKey, self.privateKey];
}

@end
