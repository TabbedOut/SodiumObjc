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
 *  A private key type that is to be used in private key operations.
 */
@interface NACLSymmetricPrivateKey : NACLKey

/**
 *  Initializes the receiver with the supplied key data. The supplied key data
 *  must be exactly `[NACLSymmetricPrivateKey keyLength]` bytes in length.
 *
 *  This is the designated initializer.
 *  
 *  @param keyData The key data that this private key should represent.
 *  @return An initialized private key.
 */
- (instancetype)initWithData:(NSData *)keyData;

@end
