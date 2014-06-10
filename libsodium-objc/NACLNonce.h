//
//  NACLNonce.h
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 Tabbedout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NACL.h"
#import "sodium.h"

@interface NACLNonce : NSData
- (id)init;
- (id)initWithNonce:(NSData*)nonce;
@end
