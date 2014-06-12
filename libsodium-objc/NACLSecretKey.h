//
//  NACLSecretKey.h
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXPORT const size_t NACLSecretKeyByteCount;

@interface NACLSecretKey : NSObject <NSCopying, NSCoding>

/**
 *  The data that represents this secret key.
 */
@property (copy, nonatomic, readonly) NSData *data;

/**
 *  Creates a randomized secret key.
 *  
 *  @return A randomized secret key.
 */
+ (instancetype)secretKey;

/**
 *  Creates a secret key around the supplied key data. The supplied key data
 *  must be exactly `NACLSecretKeyByteCount` bytes in length.
 *  
 *  @param keyData The key data that this secret key should represent.
 *  @return A secret key.
 */
+ (instancetype)secretKeyWithData:(NSData *)keyData;

/**
 *  Initializes the receiver with randomized key data.
 *  
 *  @return An secret key that has been initialized with random data.
 */
- (instancetype)init;

/**
 *  Initializes the receiver with the supplied key data. The supplied key data
 *  must be exactly `NACLSecretKeyByteCount` bytes in length.
 *
 *  This is the designated initialize.
 *  
 *  @param keyData The key data that this secret key should represent.
 *  @return An initialized secret key.
 */
- (instancetype)initWithData:(NSData *)keyData;

/**
 *  Indicates whether or not the receiver is equal to the given secret key.
 *  
 *  @param secretKey The secret key to test for equality.
 *  @return Whether or not the receiver is equal to the given secret key.
 */
- (BOOL)isEqualToSecretKey:(NACLSecretKey *)secretKey;

@end
