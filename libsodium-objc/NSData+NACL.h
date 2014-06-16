//
//  NSData+NACL.h
//  libsodium-objc
//
//  Created by Philip Jameson on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NACLAsymmetricKeyPair.h"
#import "NACLNonce.h"
#import "NACLSymmetricPrivateKey.h"
#import "NACLSigningKeyPair.h"

/**
 *  NACL augmentations to NSData.
 */
@interface NSData (NACL)

#pragma mark Public-Key Cryptography

/**
 *  Encrypts and authenticates the receiver (an `NSData` object) using the 
 *  receiving party's public key, the sending party's secret key, and a nonce.
 *  
 *  @param publicKey The receiving party's public key.
 *  @param secretKey The sending party's secret key.
 *  @param nonce     A nonce.
 *  
 *  @return An encrypted data object.
 */
- (NSData *)encryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey 
                                  nonce:(NACLNonce *)nonce;

/**
 *  Encrypts and authenticates the receiver (an `NSData` object) using the 
 *  receiving party's public key, the sending party's secret key, a nonce, 
 *  and passes back an error to the call site if one occurs.
 *  
 *  @param publicKey The receiving party's public key.
 *  @param secretKey The sending party's secret key.
 *  @param nonce     A nonce.
 *  @param outError  A pointer to an error that the call site will receive.
 *  
 *  @return An encrypted data object.
 */
- (NSData *)encryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey 
                                  nonce:(NACLNonce *)nonce
                                  error:(NSError **)outError;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) using the sending party's public key, the receiving party's
 *  secret key, and a nonce.
 *  
 *  @param publicKey The sending party's public key.
 *  @param secretKey The receiving party's secret key.
 *  @param nonce     A nonce.
 *  
 *  @return A decrypted data object.
 */
- (NSData *)decryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                  nonce:(NACLNonce *)nonce;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) using the sending party's public key, the receiving party's
 *  secret key, a nonce, and passes back an error to the call site if one 
 *  occurs.
 *  
 *  @param publicKey The sending party's public key.
 *  @param secretKey The receiving party's secret key.
 *  @param outError  A pointer to an error that the call site will receive.
 *  @param nonce     A nonce.
 *  
 *  @return A decrypted data object.
 */
- (NSData *)decryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                  nonce:(NACLNonce *)nonce
                                  error:(NSError **)outError;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) as plain text using the sending party's public key, the 
 *  receiving party's secret key, and a nonce.
 *  
 *  @param publicKey The sending party's public key.
 *  @param secretKey The receiving party's secret key.
 *  @param nonce     A nonce.
 *  
 *  @return A decrypted plain text representation of the data.
 */
- (NSString *)decryptedTextUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                               privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                    nonce:(NACLNonce *)nonce;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) as plain text using the sending party's public key, the 
 *  receiving party's secret key, a nonce, and passes back an error to the call 
 *  site if one occurs.
 *  
 *  @param publicKey The sending party's public key.
 *  @param secretKey The receiving party's secret key.
 *  @param outError  A pointer to an error that the call site will receive.
 *  @param nonce     A nonce.
 *  
 *  @return A decrypted data object.
 */
- (NSString *)decryptedTextUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                               privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                    nonce:(NACLNonce *)nonce
                                    error:(NSError **)outError;

#pragma mark Signatures

/**
 *  Signs the receiver (which is an NSData object) using the secret key in the 
 *  signer's supplied `keyPair`.
 *  
 *  @param keyPair  The signer's key pair.
 *  
 *  @return A signed data object.
 */
- (NSData *)signedDataUsingPrivateKey:(NACLSigningPrivateKey *)privateKey;

/**
 *  Signs the receiver (which is an NSData object) using the secret key in the 
 *  signer's supplied `keyPair`, and passes back an error to the call site if 
 *  one occurs.
 *  
 *  @param keyPair  The signer's key pair.
 *  @param outError A pointer to an error that the call site will receive.
 *  
 *  @return A signed data object.
 */
- (NSData *)signedDataUsingPrivateKey:(NACLSigningPrivateKey *)privateKey 
                               error:(NSError **)outError;

/**
 *  Verifies and returns the original message that has been signed by the sender
 *  using the sender's public key.
 *  
 *  @param publicKey The signer's public key.
 *  
 *  @return The original message if it can be verified with the signer's public
 *          key, or `nil` if it can not.
 */
- (NSData *)verifiedDataUsingPublicKey:(NACLSigningPublicKey *)publicKey;

/**
 *  Verifies and returns the original message that has been signed by the sender
 *  using the sender's public key and passes back an error to the call site if
 *  one occurs.
 *  
 *  @param publicKey The signer's public key.
 *  @param outError  A pointer to an error that the call site will receive.
 *  
 *  @return The original message if it can be verified with the signer's public
 *          key, or `nil` if it can not.
 */
- (NSData *)verifiedDataUsingPublicKey:(NACLSigningPublicKey *)publicKey
                                 error:(NSError **)outError;

/**
 *  Verifies and returns the original message as plain text that has been signed
 *  by the sender using the sender's public key.
 *  
 *  @param publicKey The signer's public key.
 *  
 *  @return The original message if it can be verified with the signer's public
 *          key, or `nil` if it can not.
 */
- (NSString *)verifiedTextUsingPublicKey:(NACLSigningPublicKey *)publicKey;

/**
 *  Verifies and returns the original message as plain text that has been signed
 *  by the sender using the sender's public key and passes back an error to the 
 *  call site if one occurs.
 *  
 *  @param publicKey The signer's public key.
 *  @param outError  A pointer to an error that the call site will receive.
 *  
 *  @return The original message if it can be verified with the signer's public
 *          key, or `nil` if it can not.
 */
- (NSString *)verifiedTextUsingPublicKey:(NACLSigningPublicKey *)publicKey 
                                   error:(NSError **)outError;

#pragma mark Secret-Key Cryptography

/**
 *  Encrypts and authenticates the receiver (an `NSData` object) using the 
 *  a secret key and a nonce.
 *  
 *  @param secretKey The secret key.
 *  @param nonce     A nonce.
 *  
 *  @return An encrypted data object.
 */
- (NSData *)encryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey
                                   nonce:(NACLNonce *)nonce;

/**
 *  Encrypts and authenticates the receiver (an `NSData` object) using the 
 *  a secret key, a nonce, and passes back an error to the call site if one 
 *  occurs.
 *  
 *  @param secretKey The secret key.
 *  @param nonce     The nonce.
 *  @param outError  A pointer to an error that the call site will receive.
 *  
 *  @return An encrypted data object.
 */
- (NSData *)encryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey
                                   nonce:(NACLNonce *)nonce
                                   error:(NSError **)outError;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) using a secret key and a nonce.
 *  
 *  @param secretKey The secret key.
 *  @param nonce     A nonce.
 *  
 *  @return A decrypted data object.
 */
- (NSData *)decryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey 
                                   nonce:(NACLNonce *)nonce;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) using a secret key, a nonce, and passes back an error to the 
 *  call site if one occurs.
 *  
 *  @param secretKey The secret key.
 *  @param nonce     A nonce.
 *  @param outError  A pointer to an error that the call site will receive.
 *  
 *  @return A decrypted data object.
 */
- (NSData *)decryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey 
                                   nonce:(NACLNonce *)nonce
                                   error:(NSError **)outError;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) as plain text using a secret key and a nonce.
 *  
 *  @param secretKey The secret key.
 *  @param nonce     A nonce.
 *  
 *  @return A decrypted data object.
 */
- (NSString *)decryptedTextUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey 
                                     nonce:(NACLNonce *)nonce;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) as plain text using a secret key, a nonce, and passes back 
 *  an error to the call site if one occurs.
 *  
 *  @param secretKey The secret key.
 *  @param nonce     A nonce.
 *  @param outError  A pointer to an error that the call site will receive.
 *  
 *  @return A decrypted data object.
 */
- (NSString *)decryptedTextUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey 
                                     nonce:(NACLNonce *)nonce
                                     error:(NSError **)outError;

@end
