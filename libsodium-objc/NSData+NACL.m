//
//  NSData+NACL.m
//  libsodium-objc
//
//  Created by Philip Jameson on 6/12/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NSData+NACL.h"
#import "NACL.h"
#import "NACLKeyPair.h"
#import "NACLNonce.h"

@implementation NSData (NACL)

#pragma mark Public-Key Cryptography

- (NSData *)encryptedDataUsingPublicKey:(NSData *)publicKey 
                              secretKey:(NSData *)secretKey 
                                  nonce:(NACLNonce *)nonce
{
    return [self encryptedDataUsingPublicKey:publicKey secretKey:secretKey nonce:nonce error:nil];
}


- (NSData *)encryptedDataUsingPublicKey:(NSData *)publicKey 
                              secretKey:(NSData *)secretKey 
                                  nonce:(NACLNonce *)nonce
                                  error:(NSError *__autoreleasing *)outError
{
    NSParameterAssert(publicKey);
    NSParameterAssert(secretKey);
    NSParameterAssert(nonce);
 
	[NACL initializeNACL];
    
    NSData *encryptedData = nil;
    
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
                            publicKey.bytes, 
                            secretKey.bytes);
    
	if (result != 0) {
        if (outError) {
            *outError = [NSError errorWithDomain:NACLErrorDomain 
                                            code:NACLErrorFailureCode 
                                        userInfo:nil];
        }
	} else {
        encryptedData = [NSData dataWithBytes:encryptedDataBuffer + crypto_box_BOXZEROBYTES 
                                    length:paddedMessage.length - crypto_box_BOXZEROBYTES];
	}
	
	free(encryptedDataBuffer);
    
    return encryptedData;
}

- (NSData *)decryptedDataUsingPublicKey:(NSData *)publicKey 
                              secretKey:(NSData *)secretKey 
                                  nonce:(NACLNonce *)nonce 
{
    return [self decryptedDataUsingPublicKey:publicKey secretKey:secretKey nonce:nonce error:nil];
}

- (NSData *)decryptedDataUsingPublicKey:(NSData *)publicKey 
                              secretKey:(NSData *)secretKey 
                                  nonce:(NACLNonce *)nonce
                                  error:(NSError *__autoreleasing *)outError
{
    NSParameterAssert(publicKey);
    NSParameterAssert(secretKey);
    NSParameterAssert(nonce);
    
	[NACL initializeNACL];
    
    NSData *decryptedData = nil;
    
    NSMutableData *paddedEncryptedData = [NSMutableData dataWithCapacity:self.length + crypto_box_BOXZEROBYTES];
    [paddedEncryptedData appendData:[NSMutableData dataWithLength:crypto_box_BOXZEROBYTES]];
    [paddedEncryptedData appendData:self];
    
    unsigned char message[paddedEncryptedData.length];
    
    int result = crypto_box_open(message,
                                 paddedEncryptedData.bytes,
                                 paddedEncryptedData.length,
                                 nonce.data.bytes,
                                 publicKey.bytes,
                                 secretKey.bytes);
    
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

- (NSString *)decryptedTextUsingPublicKey:(NSData *)publicKey 
                                secretKey:(NSData *)secretKey 
                                    nonce:(NACLNonce *)nonce
{
    NSString *decryptedText = nil;
    NSData *decryptedData = [self decryptedDataUsingPublicKey:publicKey secretKey:secretKey nonce:nonce];
    
    if (decryptedData.length > 0) {
        decryptedText = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    
    return decryptedText;
}

- (NSString *)decryptedTextUsingPublicKey:(NSData *)publicKey 
                                secretKey:(NSData *)secretKey 
                                    nonce:(NACLNonce *)nonce 
                                    error:(NSError *__autoreleasing *)outError
{
    NSString *decryptedText = nil;
    NSData *decryptedData = [self decryptedDataUsingPublicKey:publicKey secretKey:secretKey nonce:nonce error:outError];
    
    if (decryptedData.length > 0) {
        decryptedText = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    
    return decryptedText;
}

#pragma mark Signatures

- (NSData *)signedDataUsingSecretKey:(NSData *)secretKey error:(NSError *__autoreleasing *)outError
{
    NSParameterAssert(secretKey);

    NSData *signedData = nil;
    
    unsigned char signedMessage[self.length + crypto_sign_BYTES];
    unsigned long long signedMessageLength = 0;
    
    int result = crypto_sign(signedMessage, &signedMessageLength, self.bytes, self.length, secretKey.bytes);
    
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

- (NSData *)verifiedDataUsingPublicKey:(NSData *)publicKey error:(NSError *__autoreleasing *)outError
{
    NSParameterAssert(publicKey);
    
    NSData *messageData = nil;
    
    unsigned char message[self.length];
    unsigned long long messageLength;
    
    int result = crypto_sign_open(message, &messageLength, self.bytes, self.length, publicKey.bytes);
    
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

- (NSString *)verifiedTextUsingPublicKey:(NSData *)publicKey 
                                   error:(NSError **)outError
{
    NSData *verifiedData = [self verifiedDataUsingPublicKey:publicKey error:outError];
    NSString *verifiedText = [[NSString alloc] initWithData:verifiedData encoding:NSUTF8StringEncoding];
    
    return verifiedText;
}

#pragma mark Secret-Key Cryptography

- (NSData *)encryptedDataUsingSecretKey:(NACLSecretKey *)secretKey nonce:(NACLNonce *)nonce
{
    return [self encryptedDataUsingSecretKey:secretKey nonce:nonce error:nil];
}

- (NSData *)encryptedDataUsingSecretKey:(NACLSecretKey *)secretKey 
                                 nonce:(NACLNonce *)nonce 
                                 error:(NSError *__autoreleasing *)outError
{
    NSParameterAssert(secretKey);
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
                                  secretKey.data.bytes);

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

    return encryptedData;
}

- (NSData *)decryptedDataUsingSecretKey:(NACLSecretKey *)secretKey nonce:(NACLNonce *)nonce
{
    return [self decryptedDataUsingSecretKey:secretKey nonce:nonce error:nil];
}

- (NSData *)decryptedDataUsingSecretKey:(NACLSecretKey *)secretKey 
                                 nonce:(NACLNonce *)nonce 
                                 error:(NSError *__autoreleasing *)outError
{
    NSParameterAssert(secretKey);
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
                                       secretKey.data.bytes);
    
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

- (NSString *)decryptedTextUsingSecretKey:(NACLSecretKey *)secretKey nonce:(NACLNonce *)nonce
{
    NSString *decryptedText = nil;
    NSData *decryptedData = [self decryptedDataUsingSecretKey:secretKey nonce:nonce];
    
    if (decryptedData.length > 0) {
        decryptedText = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    
    return decryptedText;
}

- (NSString *)decryptedTextUsingSecretKey:(NACLSecretKey *)secretKey 
                                   nonce:(NACLNonce *)nonce 
                                   error:(NSError *__autoreleasing *)outError
{
    NSString *decryptedText = nil;
    NSData *decryptedData = [self decryptedDataUsingSecretKey:secretKey nonce:nonce error:outError];
    
    if (decryptedData.length > 0) {
        decryptedText = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    }
    
    return decryptedText;
}

@end
