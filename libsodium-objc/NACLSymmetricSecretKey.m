//
//  NACLSymmetricSecretKey.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLSymmetricSecretKey.h"
#import "NACL.h"
#import "NACLKeySubclass.h"

const size_t NACLSecretKeyByteCount = crypto_secretbox_KEYBYTES;

@implementation NACLSymmetricSecretKey

- (instancetype)initWithData:(NSData *)keyData
{
    NSParameterAssert([keyData length] == NACLSecretKeyByteCount);
    
    self = [super initWithData:keyData];
    
    return self;
}

- (NSData *)generateDefaultKeyData
{
    unsigned char *keyDataBuffer = calloc(NACLSecretKeyByteCount, sizeof(unsigned char));
    randombytes_buf(keyDataBuffer, NACLSecretKeyByteCount);
    
    NSData *keyData = [[NSData alloc] initWithBytes:keyDataBuffer length:NACLSecretKeyByteCount];
    
    return keyData;
}

@end
