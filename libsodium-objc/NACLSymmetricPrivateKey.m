//
//  NACLSymmetricPrivateKey.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLSymmetricPrivateKey.h"
#import "NACL.h"

@implementation NACLSymmetricPrivateKey

+ (NSUInteger)keyLength
{
    return crypto_secretbox_KEYBYTES;
}

- (instancetype)initWithData:(NSData *)keyData
{
    NSParameterAssert([keyData length] == [[self class] keyLength]);
    
    self = [super initWithData:keyData];
    
    return self;
}

- (NSData *)generateDefaultKeyData
{
    NSUInteger keyLength = [[self class] keyLength];
    
    unsigned char *keyDataBuffer = calloc(keyLength, sizeof(unsigned char));
    randombytes_buf(keyDataBuffer, keyLength);
    
    NSData *keyData = [[NSData alloc] initWithBytes:keyDataBuffer length:keyLength];
    
    return keyData;
}

@end
