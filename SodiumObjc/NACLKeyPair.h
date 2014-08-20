//
//  NACLKeyPair.h
//  
//
//  Created by Damian Carrillo on 6/16/14.
//
//

#import <Foundation/Foundation.h>
#import "NACLKey.h"

@interface NACLKeyPair : NSObject <NSCopying, NSSecureCoding>
@property (strong, nonatomic, readonly) NACLKey *publicKey;
@property (strong, nonatomic, readonly) NACLKey *privateKey;

/**
 *  Creates a signing key pair.
 *  
 *  @return A key pair, whose public key and private key are initialized with 
 *          appropriate values.
 */
+ (instancetype)keyPair;

/**
 *  Creates a key pair using the given seed.
 *  
 *  @param seed The seed data that is used to generate the keys. The seed you 
 *              supply may be `nil`, and if it is, this creation method devolves
 *              into `+ keyPair`.
 *  @return A created key pair object, whose public key and private key are
 *          initialized with appropriate values.
 */
+ (instancetype)keyPairWithSeed:(NSData *)seed;

/**
 *  Returns the number of bytes that the seed supplied to `keyPairWithSeed` or
 *  `initWithSeed` should be.
 *  
 *  @return The number of bytes that the seed is.
 */
+ (NSUInteger)seedLength;

/**s
 *  Initializes this key pair given the given seed.
 *
 *  This is the designated initializer.
 *  
 *  @param seed The seed data that is used to generate the 
 *  @return An initialized key pair.
 */
- (instancetype)initWithSeed:(NSData *)seed;

/**
 *  Indicates whether or not the receiver is equal to the given key pair. 
 *  Equality is determined by `publicKey` and `privateKey` being equal for both
 *  the receiver and the given key pair.
 *  
 *  @param keyPair The key pair to test for equality.
 *  @return Whether or not the receiver is equal to the given key pair.
 */
- (BOOL)isEqualToKeyPair:(NACLKeyPair *)keyPair;

@end
