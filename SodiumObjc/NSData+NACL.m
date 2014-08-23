//
//  NSData+NACL.m
//  libsodium-objc
//
//  Created by Philip Jameson on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <sodium.h>
#import "NSData+NACL.h"
#import "NACL.h"
#import "NACLNonce.h"

@implementation NSData (NACL)

- (NSData *)dataWithoutNonce
{
    NSRange encryptedDataRange = {0, self.length - [NACLNonce nonceLength]};
    return [self subdataWithRange:encryptedDataRange];
}

#pragma mark - Public-Key Encryption

- (NSData *)encryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey 
                                  nonce:(NACLNonce *)nonce
{
    return [self encryptedDataUsingPublicKey:publicKey privateKey:privateKey nonce:nonce error:nil];
}


- (NSData *)encryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey 
                                  nonce:(NACLNonce *)nonce
                                  error:(NSError *__autoreleasing *)outError
{
    NSParameterAssert(publicKey);
    NSParameterAssert(privateKey);
    NSParameterAssert(nonce);
 
	[NACL initializeNACL];
    
    NSMutableData *paddedMessage = [NSMutableData dataWithCapacity:crypto_box_ZEROBYTES + self.length];
    [paddedMessage appendData:[NSMutableData dataWithLength:crypto_box_ZEROBYTES]];
    [paddedMessage appendData:self];
	
	unsigned char *encryptedDataBuffer = calloc(paddedMessage.length, sizeof(unsigned char));
    
	if (encryptedDataBuffer == NULL) {
        if (outError) {
            *outError = [NSError errorWithDomain:NACLErrorDomain 
                                            code:NACLErrorAllocationErrorCode 
                                        userInfo:nil];
        }
        
		return nil;
	}
    
    int result = crypto_box(encryptedDataBuffer, 
                            paddedMessage.bytes, 
                            paddedMessage.length, 
                            nonce.data.bytes, 
                            publicKey.data.bytes, 
                            privateKey.data.bytes);
    
    NSData *encryptedData = nil;
    
	if (result != 0) {
        if (outError) {
            *outError = [NSError errorWithDomain:NACLErrorDomain 
                                            code:NACLErrorFailureCode 
                                        userInfo:nil];
        }
	} else {
        NSMutableData *encryptedDataPlusNonce = [NSMutableData data];
        [encryptedDataPlusNonce appendBytes:encryptedDataBuffer + crypto_box_BOXZEROBYTES
                                     length:paddedMessage.length - crypto_box_BOXZEROBYTES];
        [encryptedDataPlusNonce appendData:nonce.data];
        encryptedData = [encryptedDataPlusNonce copy];
	}
	
	free(encryptedDataBuffer);
    
    return encryptedData;
}

#pragma mark Public-Key Decryption

- (NSData *)decryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey
{
    return [self decryptedDataUsingPublicKey:publicKey privateKey:privateKey nonce:nil error:nil];
}

- (NSData *)decryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                  error:(NSError *__autoreleasing *)outError
{
    return [self decryptedDataUsingPublicKey:publicKey privateKey:privateKey nonce:nil error:outError];
}

- (NSData *)decryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey 
                                  nonce:(NACLNonce *)nonce 
{
    return [self decryptedDataUsingPublicKey:publicKey privateKey:privateKey nonce:nonce error:nil];
}

- (NSData *)decryptedDataUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                             privateKey:(NACLAsymmetricPrivateKey *)privateKey 
                                  nonce:(NACLNonce *)nonce
                                  error:(NSError *__autoreleasing *)outError
{
    NSParameterAssert(publicKey);
    NSParameterAssert(privateKey);
    
	[NACL initializeNACL];
    
    NSUInteger packedNonceLength = 0;
    
    if (!nonce) {
        NSRange nonceDataRange = {self.length - [NACLNonce nonceLength], [NACLNonce nonceLength]};
        NSData *nonceData = [self subdataWithRange:nonceDataRange];
        nonce = [NACLNonce nonceWithData:nonceData];
        packedNonceLength = [NACLNonce nonceLength];
    }
    
    NSData *decryptedData = nil;
    
    NSMutableData *paddedEncryptedData = [NSMutableData dataWithCapacity:self.length + crypto_box_BOXZEROBYTES - packedNonceLength];
    [paddedEncryptedData appendData:[NSMutableData dataWithLength:crypto_box_BOXZEROBYTES]];
    
    NSRange encryptedDataRange = {0, self.length - packedNonceLength};
    [paddedEncryptedData appendData:[self subdataWithRange:encryptedDataRange]];
    
    unsigned char message[paddedEncryptedData.length];
    
    int result = crypto_box_open(message,
                                 paddedEncryptedData.bytes,
                                 paddedEncryptedData.length,
                                 nonce.data.bytes,
                                 publicKey.data.bytes,
                                 privateKey.data.bytes);
    
	if (result != 0) {
        if (outError) {
            *outError = [NSError errorWithDomain:NACLErrorDomain 
                                            code:NACLErrorFailureCode 
                                        userInfo:nil];
        }
        
        return nil;
	} else {
        decryptedData = [NSData dataWithBytes:message + crypto_box_ZEROBYTES 
                                       length:paddedEncryptedData.length - crypto_box_ZEROBYTES];
    }
    
	return decryptedData;
}

- (NSString *)decryptedTextUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                               privateKey:(NACLAsymmetricPrivateKey *)privateKey
{
    return [self decryptedTextUsingPublicKey:publicKey privateKey:privateKey nonce:nil error:nil];
}

- (NSString *)decryptedTextUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey
                               privateKey:(NACLAsymmetricPrivateKey *)privateKey
                                    error:(NSError *__autoreleasing *)outError
{
    return [self decryptedTextUsingPublicKey:publicKey privateKey:privateKey nonce:nil error:outError];
}

- (NSString *)decryptedTextUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                               privateKey:(NACLAsymmetricPrivateKey *)privateKey 
                                    nonce:(NACLNonce *)nonce
{
    NSString *decryptedText = nil;
    NSData *decryptedData = [self decryptedDataUsingPublicKey:publicKey privateKey:privateKey nonce:nonce];
    
    if (decryptedData.length > 0) {
        decryptedText = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    
    return decryptedText;
}

- (NSString *)decryptedTextUsingPublicKey:(NACLAsymmetricPublicKey *)publicKey 
                               privateKey:(NACLAsymmetricPrivateKey *)privateKey 
                                    nonce:(NACLNonce *)nonce 
                                    error:(NSError *__autoreleasing *)outError
{
    NSString *decryptedText = nil;
    NSData *decryptedData = [self decryptedDataUsingPublicKey:publicKey privateKey:privateKey nonce:nonce error:outError];
    
    if (decryptedData.length > 0) {
        decryptedText = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    
    return decryptedText;
}

#pragma mark - Private-Key Encryption

- (NSData *)encryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey nonce:(NACLNonce *)nonce
{
    return [self encryptedDataUsingPrivateKey:privateKey nonce:nonce error:nil];
}

- (NSData *)encryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey 
                                 nonce:(NACLNonce *)nonce 
                                 error:(NSError *__autoreleasing *)outError
{
    NSParameterAssert(privateKey);
    NSParameterAssert(nonce);
    
	[NACL initializeNACL];
    
    NSData *encryptedData = nil;
    
    NSMutableData *paddedMessage = [NSMutableData dataWithCapacity:crypto_secretbox_ZEROBYTES + self.length];
    [paddedMessage appendData:[NSMutableData dataWithLength:crypto_secretbox_ZEROBYTES]];
    [paddedMessage appendData:self];

	unsigned char *encryptedDataBuffer = calloc(paddedMessage.length, sizeof(unsigned char));
    
	if (encryptedDataBuffer == NULL) {
        if (outError) {
            *outError = [NSError errorWithDomain:NACLErrorDomain 
                                            code:NACLErrorAllocationErrorCode 
                                        userInfo:nil];
        }
        
		return nil;
	}

    
    int result = crypto_secretbox(encryptedDataBuffer, 
                                  paddedMessage.bytes, 
                                  paddedMessage.length, 
                                  nonce.data.bytes, 
                                  privateKey.data.bytes);

	if (result != 0) {
        if (outError) {
            *outError = [NSError errorWithDomain:NACLErrorDomain 
                                            code:NACLErrorFailureCode 
                                        userInfo:nil];
        }
	} else {
        encryptedData = [NSData dataWithBytes:encryptedDataBuffer + crypto_secretbox_BOXZEROBYTES
                                    length:paddedMessage.length - crypto_secretbox_BOXZEROBYTES];
	}
    
    free(encryptedDataBuffer);

    return encryptedData;
}

#pragma mark Private-Key Decryption

- (NSData *)decryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey nonce:(NACLNonce *)nonce
{
    return [self decryptedDataUsingPrivateKey:privateKey nonce:nonce error:nil];
}

- (NSData *)decryptedDataUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey 
                                 nonce:(NACLNonce *)nonce 
                                 error:(NSError *__autoreleasing *)outError
{
    NSParameterAssert(privateKey);
    NSParameterAssert(nonce);
    
	[NACL initializeNACL];
    
    NSData *decryptedData = nil;
    
    NSMutableData *paddedEncryptedData = [NSMutableData dataWithCapacity:self.length + crypto_secretbox_BOXZEROBYTES];
    [paddedEncryptedData appendData:[NSMutableData dataWithLength:crypto_secretbox_BOXZEROBYTES]];
    [paddedEncryptedData appendData:self];
    
    unsigned char message[paddedEncryptedData.length];
    
    int result = crypto_secretbox_open(message,
                                       paddedEncryptedData.bytes,
                                       paddedEncryptedData.length,
                                       nonce.data.bytes,
                                       privateKey.data.bytes);
    
	if (result != 0) {
        if (outError) {
            *outError = [NSError errorWithDomain:NACLErrorDomain 
                                            code:NACLErrorFailureCode 
                                        userInfo:nil];
        }
        
        return nil;
	} else {
        decryptedData = [NSData dataWithBytes:message + crypto_secretbox_ZEROBYTES
                                       length:paddedEncryptedData.length - crypto_secretbox_ZEROBYTES];
    }
    
	return decryptedData;
}

- (NSString *)decryptedTextUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey nonce:(NACLNonce *)nonce
{
    NSString *decryptedText = nil;
    NSData *decryptedData = [self decryptedDataUsingPrivateKey:privateKey nonce:nonce];
    
    if (decryptedData.length > 0) {
        decryptedText = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    
    return decryptedText;
}

- (NSString *)decryptedTextUsingPrivateKey:(NACLSymmetricPrivateKey *)privateKey 
                                   nonce:(NACLNonce *)nonce 
                                   error:(NSError *__autoreleasing *)outError
{
    NSString *decryptedText = nil;
    NSData *decryptedData = [self decryptedDataUsingPrivateKey:privateKey nonce:nonce error:outError];
    
    if (decryptedData.length > 0) {
        decryptedText = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    
    return decryptedText;
}

#pragma mark - Signing

- (NSData *)signedDataUsingPrivateKey:(NACLSigningPrivateKey *)privateKey
{
    return [self signedDataUsingPrivateKey:privateKey error:nil];
}

- (NSData *)signedDataUsingPrivateKey:(NACLSigningPrivateKey *)privateKey error:(NSError *__autoreleasing *)outError
{
    NSParameterAssert(privateKey);
    
    NSData *signedData = nil;
    
    unsigned char signedMessage[self.length + crypto_sign_BYTES];
    unsigned long long signedMessageLength = 0;
    
    int result = crypto_sign(signedMessage,
                             &signedMessageLength,
                             self.bytes,
                             self.length,
                             privateKey.data.bytes);
    
    if (result != 0) {
        if (outError) {
            *outError = [NSError errorWithDomain:NACLErrorDomain
                                            code:NACLErrorFailureCode
                                        userInfo:nil];
        }
    } else {
        signedData = [NSData dataWithBytes:signedMessage length:(NSUInteger) signedMessageLength];
    }
    
    return signedData;
}

#pragma mark Verification

- (NSData *)verifiedDataUsingPublicKey:(NACLSigningPublicKey *)publicKey
{
    return [self verifiedDataUsingPublicKey:publicKey error:nil];
}

- (NSData *)verifiedDataUsingPublicKey:(NACLSigningPublicKey *)publicKey error:(NSError *__autoreleasing *)outError
{
    NSParameterAssert(publicKey);
    
    NSData *messageData = nil;
    
    unsigned char message[self.length];
    unsigned long long messageLength;
    
    int result = crypto_sign_open(message,
                                  &messageLength,
                                  self.bytes,
                                  self.length,
                                  publicKey.data.bytes);
    
    if (result != 0) {
        if (outError) {
            *outError = [NSError errorWithDomain:NACLErrorDomain
                                            code:NACLErrorFailureCode
                                        userInfo:nil];
        }
    } else {
        messageData = [NSData dataWithBytes:message length:(NSUInteger) messageLength];
    }
    
    return messageData;
}

- (NSString *)verifiedTextUsingPublicKey:(NACLSigningPublicKey *)publicKey
{
    return [self verifiedTextUsingPublicKey:publicKey error:nil];
}

- (NSString *)verifiedTextUsingPublicKey:(NACLSigningPublicKey *)publicKey
                                   error:(NSError **)outError
{
    NSData *verifiedData = [self verifiedDataUsingPublicKey:publicKey error:outError];
    NSString *verifiedText = [[NSString alloc] initWithData:verifiedData encoding:NSUTF8StringEncoding];
    
    return verifiedText;
}

@end
