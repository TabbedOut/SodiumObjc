//
//  NACLSymmetricPrivateKey.h
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NACLKey.h"

/**
 *  A secret key type that is to be used in secret key operations.
 */
@interface NACLSymmetricPrivateKey : NACLKey

/**
 *  Initializes the receiver with the supplied key data. The supplied key data
 *  must be exactly `[NACLSymmetricPrivateKey keyLength]` bytes in length.
 *
 *  This is the designated initializer.
 *  
 *  @param keyData The key data that this secret key should represent.
 *  @return An initialized secret key.
 */
- (instancetype)initWithData:(NSData *)keyData;

@end
