//
//  NACLPrivateKey.h
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 Tabbedout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NACL.h"
#import "NACLPublicKey.h"
#import "sodium.h"

@interface NACLPrivateKey : NSData
@property (strong, nonatomic, readonly) NACLPublicKey* publicKey;

- (id)init;
- (id)initWithSeed:(NSData*)seed;
@end
