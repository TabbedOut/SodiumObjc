//
//  NACLSymmetricPrivateKey.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLSymmetricPrivateKey.h"
#import "NACL.h"
#import "NACLKeySubclass.h"

const size_t NACLSymmetricPrivateKeyByteCount = crypto_secretbox_KEYBYTES;

@implementation NACLSymmetricPrivateKey

- (instancetype)initWithData:(NSData *)keyData
{
    NSParameterAssert([keyData length] == NACLSymmetricPrivateKeyByteCount);
    
    self = [super initWithData:keyData];
    
    return self;
}

- (NSData *)generateDefaultKeyData
{
    unsigned char *keyDataBuffer = calloc(NACLSymmetricPrivateKeyByteCount, sizeof(unsigned char));
    randombytes_buf(keyDataBuffer, NACLSymmetricPrivateKeyByteCount);
    
    NSData *keyData = [[NSData alloc] initWithBytes:keyDataBuffer length:NACLSymmetricPrivateKeyByteCount];
    
    return keyData;
}

@end
