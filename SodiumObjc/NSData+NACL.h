//
//  NSData+NACL.h
//  libsodium-objc
//
//  Created by Philip Jameson on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SodiumObjc/NACLAsymmetricKeyPair.h>
#import <SodiumObjc/NACLNonce.h>
#import <SodiumObjc/NACLSymmetricPrivateKey.h>
#import <SodiumObjc/NACLSigningKeyPair.h>

/**
 *  NACL augmentations to NSData.
 */
@interface NSData (NACL)

#pragma mark - Utility

/**
 *  Returns encrypted data after stripping the nonce from the receiver.
 *
 *  @return Encrypted data without a nonce.
 */
- (NSData *)dataWithoutNonce;

#pragma mark - Public-Key Encryption

/**
 *  Encrypts and authenticates the receiver (an `NSData` object) using the 
 *  receiving party's public key, the sending party's private key, and a nonce.
 *
 *  Nonce data is packed into the end of the returned data object.
 *  
 *  @param publicKey  The receiving party's public key.
 *  @param privateKey The sending party's private key.
 *  @param nonce      A nonce.
 *  
 *  @return An encrypted data object.
 */
- (NSData *)encryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey 
                                  nonce:(NACLNonce *)nonce;

/**
 *  Encrypts and authenticates the receiver (an `NSData` object) using the 
 *  receiving party's public key, the sending party's private key, a nonce,
 *  and passes back an error to the call site if one occurs.
 *
 *  Nonce data is packed into the end of the returned data object.
 *  
 *  @param publicKey  The receiving party's public key.
 *  @param privateKey The sending party's private key.
 *  @param nonce      A nonce.
 *  @param outError   A pointer to an error that the call site will receive.
 *  
 *  @return An encrypted data object.
 */
- (NSData *)encryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey 
                                  nonce:(NACLNonce *)nonce
                                  error:(NSError **)outError;

#pragma mark Public-Key Decryption

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted
 *  NSData object) using the sending party's public key and the receiving party's
 *  private key.
 *
 *  Nonce data is expected to be packed into the end of receiver.
 *
 *  @param publicKey  The sending party's public key.
 *  @param privateKey The receiving party's private key.
 *
 *  @return A decrypted data object.
 */
- (NSData *)decryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted
 *  NSData object) using the sending party's public key, the receiving party's
 *  private key, and passes back an error to the call site if one occurs.
 *
 *  Nonce data is expected to be packed into the end of receiver.
 *
 *  @param publicKey  The sending party's public key.
 *  @param privateKey The receiving party's private key.
 *  @param outError   A pointer to an error that the call site will receive.
 *
 *  @return A decrypted data object.
 */
- (NSData *)decryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                  error:(NSError *__autoreleasing *)outError;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) using the sending party's public key, the receiving party's
 *  private key, and a nonce.
 *
 *  Nonce data is expected to not be packed into the end of receiver.
 *  
 *  @param publicKey  The sending party's public key.
 *  @param privateKey The receiving party's private key.
 *  @param nonce      A nonce.
 *  
 *  @return A decrypted data object.
 */
- (NSData *)decryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                  nonce:(NACLNonce *)nonce;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) using the sending party's public key, the receiving party's
 *  private key, a nonce, and passes back an error to the call site if one
 *  occurs.
 *
 *  Nonce data is expected to not be packed into the end of receiver.
 *  
 *  @param publicKey  The sending party's public key.
 *  @param privateKey The receiving party's private key.
 *  @param nonce      A nonce.
 *  @param outError   A pointer to an error that the call site will receive.
 *
 *  @return A decrypted data object.
 */
- (NSData *)decryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                  nonce:(NACLNonce *)nonce
                                  error:(NSError **)outError;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted
 *  NSData object) as plain text using the sending party's public key and the
 *  receiving party's private key.
 *
 *  Nonce data is expected to be packed into the end of receiver.
 *
 *  @param publicKey  The sending party's public key.
 *  @param privateKey The receiving party's private key.
 *
 *  @return A decrypted plain text representation of the data.
 */
- (NSString *)decryptedTextUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                               privateKey:(NACLAsymmetricPrivateKey *)privateKey;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted
 *  NSData object) as plain text using the sending party's public key, the
 *  receiving party's private key, and passes back an error to the call
 *  site if one occurs.
 *
 *  Nonce data is expected to be packed into the end of receiver.
 *
 *  @param publicKey  The sending party's public key.
 *  @param privateKey The receiving party's private key.
 *  @param outError   A pointer to an error that the call site will receive.
 *
 *  @return A decrypted data object.
 */
- (NSString *)decryptedTextUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                               privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                    error:(NSError **)outError;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) as plain text using the sending party's public key, the 
 *  receiving party's private key, and a nonce.
 *
 *  Nonce data is expected to not be packed into the end of receiver.
 *  
 *  @param publicKey  The sending party's public key.
 *  @param privateKey The receiving party's private key.
 *  @param nonce      A nonce.
 *  
 *  @return A decrypted plain text representation of the data.
 */
- (NSString *)decryptedTextUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                               privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                    nonce:(NACLNonce *)nonce;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) as plain text using the sending party's public key, the 
 *  receiving party's private key, a nonce, and passes back an error to the call
 *  site if one occurs.
 *
 *  Nonce data is expected to not be packed into the end of receiver.
 *  
 *  @param publicKey  The sending party's public key.
 *  @param privateKey The receiving party's private key.
 *  @param nonce      A nonce.
 *  @param outError   A pointer to an error that the call site will receive.
 *
 *  @return A decrypted data object.
 */
- (NSString *)decryptedTextUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                               privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                    nonce:(NACLNonce *)nonce
                                    error:(NSError **)outError;

#pragma mark - Private-Key Encryption

/**
 *  Encrypts and authenticates the receiver (an `NSData` object) using the 
 *  a private key and a nonce.
 *
 *  Nonce data is packed into the end of the returned data object.
 *  
 *  @param privateKey The private key.
 *  @param nonce      A nonce.
 *  
 *  @return An encrypted data object.
 */
- (NSData *)encryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey
                                   nonce:(NACLNonce *)nonce;

/**
 *  Encrypts and authenticates the receiver (an `NSData` object) using the 
 *  a private key, a nonce, and passes back an error to the call site if one
 *  occurs.
 *
 *  Nonce data is packed into the end of the returned data object.
 *  
 *  @param privateKey The private key.
 *  @param nonce      The nonce.
 *  @param outError   A pointer to an error that the call site will receive.
 *  
 *  @return An encrypted data object.
 */
- (NSData *)encryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey
                                   nonce:(NACLNonce *)nonce
                                   error:(NSError **)outError;

#pragma mark Private-Key Decryption

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted
 *  NSData object) using a private key.
 *
 *  Nonce data is expected to not be packed into the end of receiver.
 *
 *  @param privateKey The private key.
 *
 *  @return A decrypted data object.
 */
- (NSData *)decryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted
 *  NSData object) using a private key, a nonce, and passes back an error to the
 *  call site if one occurs.
 *
 *  Nonce data is expected to not be packed into the end of receiver.
 *
 *  @param privateKey The private key.
 *  @param outError   A pointer to an error that the call site will receive.
 *
 *  @return A decrypted data object.
 */
- (NSData *)decryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey
                                   error:(NSError **)outError;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) using a private key and a nonce.
 *
 *  Nonce data is expected to not be packed into the end of receiver.
 *  
 *  @param privateKey The private key.
 *  @param nonce      A nonce.
 *  
 *  @return A decrypted data object.
 */
- (NSData *)decryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey 
                                   nonce:(NACLNonce *)nonce;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) using a private key, a nonce, and passes back an error to the
 *  call site if one occurs.
 *
 *  Nonce data is expected to not be packed into the end of receiver.
 *  
 *  @param privateKey The private key.
 *  @param nonce      A nonce.
 *  @param outError   A pointer to an error that the call site will receive.
 *  
 *  @return A decrypted data object.
 */
- (NSData *)decryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey 
                                   nonce:(NACLNonce *)nonce
                                   error:(NSError **)outError;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) as plain text using a private key and a nonce.
 *
 *  Nonce data is expected to not be packed into the end of receiver.
 *  
 *  @param privateKey The private key.
 *  @param nonce      A nonce.
 *  
 *  @return A decrypted data object.
 */
- (NSString *)decryptedTextUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey 
                                     nonce:(NACLNonce *)nonce;

/**
 *  Verifies and decrypts the reciever (which is assumed to be an encrypted 
 *  NSData object) as plain text using a private key, a nonce, and passes back
 *  an error to the call site if one occurs.
 *
 *  Nonce data is expected to not be packed into the end of receiver.
 *  
 *  @param privateKey The private key.
 *  @param nonce      A nonce.
 *  @param outError   A pointer to an error that the call site will receive.
 *  
 *  @return A decrypted data object.
 */
- (NSString *)decryptedTextUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey 
                                     nonce:(NACLNonce *)nonce
                                     error:(NSError **)outError;

#pragma mark - Signing

/**
 *  Signs the receiver (which is an NSData object) using the private key in the
 *  signer's supplied `keyPair`.
 *
 *  @param keyPair  The signer's key pair.
 *
 *  @return A signed data object.
 */
- (NSData *)signedDataUsingPrivateKey:(NACLSigningPrivateKey *)privateKey;

/**
 *  Signs the receiver (which is an NSData object) using the private key in the
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

#pragma mark Verification

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

@end
