//
//  NACLNonce.h
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A nonce type.
 */
@interface NACLNonce : NSObject <NSCopying, NSSecureCoding>
@property (strong, nonatomic, readonly) NSData *data;

+ (instancetype)nonce;

/**
 *  Creates this nonce with random bytes. This is the default behavior.
 *  
 *  @return An nonce initialized with random bytes.
 */
+ (instancetype)nonceFromRandomBytes;

/**
 *  Creates a nonce from the timestamp that is taken with the message is sent.
 *  
 *  @return An nonce initialized around the timestamp.
 */
+ (instancetype)nonceFromTimestamp;

/**
 *  Creates a nonce with the nonce data. The nonce data must be
 *  exactly `[NACLNonce nonceLength]` bytes.
 *  
 *  @param nonceData The data to use in the nonce. This must be contain EXACTLY
 *                   `[NACLNonce nonceLength]` bytes.
 *  @return An nonce that has been initialized with the given data if it is of
 *          the correct byte count, or nil if it is not.
 */
+ (instancetype)nonceWithData:(NSData *)nonceData;

/**
 *  The length of a nonce. All nonces are the same length.
 *
 *  @return The length of the nonce.
 */
+ (NSUInteger)nonceLength;

/**
 *  Initializes this nonce with random bytes. This is the default behavior.
 *  
 *  @return An nonce initialized with random bytes.
 */
- (instancetype)initWithRandomBytes;

/**
 *  Initializes this nonce with the timestamp that is taken with the message is
 *  sent.
 *  
 *  @return An nonce initialized around the timestamp.
 */
- (instancetype)initWithTimestamp;

/**
 *  Initializes this nonce with the given nonce data. The nonce data must be
 *  exactly `[NACLNonce nonceLength]` bytes.
 *  
 *  @param nonceData The data to use in the nonce. This must be contain EXACTLY
 *                   `[NACLNonce nonceLength]` bytes.
 *  @return An nonce that has been initialized with the given data if it is of
 *          the correct byte count, or nil if it is not.
 */
- (instancetype)initWithData:(NSData *)nonceData;

/**
 *  Indicates whether or not the receiver is equal to the given nonce.
 *  
 *  @param nonce The nonce to test for equality.
 *  @return Whether or not the receiver is equal to the given nonce.
 */
- (BOOL)isEqualToNonce:(NACLNonce *)nonce;

@end
