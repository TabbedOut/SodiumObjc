//
//  NACLKey.h
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NACLKey : NSObject <NSCopying, NSSecureCoding>

/**
 *  The data that represents this key.
 */
@property (copy, nonatomic, readonly) NSData *data;

/**
 *  Creates a default key.
 *  
 *  @return A default key.
 */
+ (instancetype)key;

/**
 *  Creates a key around the supplied key data.
 *  
 *  @param keyData The key data that this key represents.
 *  @return A key.
 */
+ (instancetype)keyWithData:(NSData *)keyData;

/**
 *  Returns the length of the key.
 *  
 *  @return The key length.
 */
+ (NSUInteger)keyLength;

/**
 *  Initializes the receiver with the supplied key data.
 *  
 *  @param keyData The key data that this private key should represent.
 *  @return An initialized private key.
 */
- (instancetype)initWithData:(NSData *)keyData;

/**
 *  Indicates whether or not the given key is equal to the receiver.
 *  
 *  @param key The key to test for equality.
 *  
 *  @return Return whether or not the given key is equal to the receiver.
 */
- (BOOL)isEqualToKey:(NACLKey *)key;

@end
