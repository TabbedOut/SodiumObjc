//
//  NACLBox.m
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 Tabbedout. All rights reserved.
//

#import "NACLBox.h"

@implementation NACLBox
+ (void)initialize {
	[NACL initialize];
	[super initialize];
}

+ (NSData*)encryptMessage:(NSData *)message
			  withPrivate:(NACLPrivateKey *)privateKey
				   public:(NACLPublicKey *)publicKey
				 andNonce:(NSData *)nonce
					error:(NSError **)error {
	if(privateKey.length != crypto_box_SECRETKEYBYTES) {
		WRAP_NSERROR(error, [NSError errorWithDomain:@"Box" code:NACL_BOX_SECRET_LENGTH userInfo:nil]);
		return nil;
	}
	if(publicKey.length != crypto_box_PUBLICKEYBYTES) {
		WRAP_NSERROR(error, [NSError errorWithDomain:@"Box" code:NACL_BOX_PUBLIC_LENGTH userInfo:nil]);
		return nil;
	}
	if(nonce.length != crypto_box_NONCEBYTES) {
		WRAP_NSERROR(error, [NSError errorWithDomain:@"Box" code:NACL_BOX_NONCE_LENGTH userInfo:nil]);
		return nil;
	}
	
	size_t paddedLength = crypto_box_ZEROBYTES + message.length;
	unsigned char* paddedMessage = calloc(paddedLength, sizeof(unsigned char));
	if(paddedMessage == NULL){
		WRAP_NSERROR(error, [NSError errorWithDomain:@"Box" code:NACL_BOX_ALLOCATION_ERROR userInfo:nil]);
		return nil;
	}
	
	unsigned char* paddedEncryptedMessage = calloc(paddedLength, sizeof(unsigned char));
	if(paddedEncryptedMessage == NULL) {
		free(paddedMessage);
		WRAP_NSERROR(error, [NSError errorWithDomain:@"Box" code:NACL_BOX_ALLOCATION_ERROR userInfo:nil]);
		return nil;
	}
	
	memcpy(paddedMessage + crypto_box_ZEROBYTES, message.bytes, message.length);
	
	NSData* ret = nil;
	if(crypto_box(paddedEncryptedMessage, paddedMessage, paddedLength, nonce.bytes, publicKey.bytes, privateKey.bytes) != 0) {
		WRAP_NSERROR(error, [NSError errorWithDomain:@"Box" code:NACL_BOX_FAILED userInfo:nil]);
	} else {
		ret = [NSData dataWithBytes:(paddedEncryptedMessage + crypto_box_ZEROBYTES) length:(paddedLength - crypto_box_ZEROBYTES)];
	}
	
	free(paddedMessage);
	free(paddedEncryptedMessage);
	return ret;
	
}

+ (NSData*)decryptMessage:(NSData *)encryptedMessage
			  withPrivate:(NACLPrivateKey *)privateKey
				   public:(NACLPublicKey *)publicKey
					nonce:(NACLNonce**)nonce
					error:(NSError **)error {
	
	if(privateKey.length != crypto_box_SECRETKEYBYTES) {
		WRAP_NSERROR(error, [NSError errorWithDomain:@"Box" code:NACL_BOX_SECRET_LENGTH userInfo:nil]);
		return nil;
	}
	if(publicKey.length != crypto_box_PUBLICKEYBYTES) {
		WRAP_NSERROR(error, [NSError errorWithDomain:@"Box" code:NACL_BOX_PUBLIC_LENGTH userInfo:nil]);
		return nil;
	}
	if(encryptedMessage.length <= crypto_box_NONCEBYTES) {
		WRAP_NSERROR(error, [NSError errorWithDomain:@"Box" code:NACL_BOX_MESSAGE_LENGTH userInfo:nil]);
		return nil;
	}
		
	size_t paddedLength = crypto_box_ZEROBYTES + encryptedMessage.length - crypto_box_NONCEBYTES;
	unsigned char* paddedEncryptedMessage = NULL;
	unsigned char* paddedDecryptedMessage = NULL;
	unsigned char nonceBuffer[crypto_box_NONCEBYTES];
	
	paddedEncryptedMessage = calloc(paddedLength, sizeof(unsigned char));
	if(paddedEncryptedMessage == NULL){
		WRAP_NSERROR(error, [NSError errorWithDomain:@"Box" code:NACL_BOX_ALLOCATION_ERROR userInfo:nil]);
		return nil;
	}

	paddedDecryptedMessage  = calloc(paddedLength, sizeof(unsigned char));
	if(paddedDecryptedMessage == NULL){
		free(paddedEncryptedMessage);
		WRAP_NSERROR(error, [NSError errorWithDomain:@"Box" code:NACL_BOX_ALLOCATION_ERROR userInfo:nil]);
		return nil;
	}

	memcpy(nonceBuffer, encryptedMessage.bytes, crypto_box_NONCEBYTES);
	memcpy(paddedEncryptedMessage + crypto_box_ZEROBYTES, encryptedMessage.bytes, encryptedMessage.length);
	
	NSData* ret = nil;
	if(crypto_box_open(paddedDecryptedMessage, paddedEncryptedMessage, paddedLength, nonceBuffer, publicKey.bytes, privateKey.bytes) != 0) {
		WRAP_NSERROR(error, [NSError errorWithDomain:@"Box" code:NACL_BOX_FAILED userInfo:nil]);
	} else {
		if(nonce != NULL){
			*nonce = [[NACLNonce alloc] initWithNonce:[NSData dataWithBytes:nonceBuffer length:crypto_box_NONCEBYTES]];
		}
		ret = [NSData dataWithBytes:(paddedDecryptedMessage + crypto_box_ZEROBYTES) length:(paddedLength - crypto_box_ZEROBYTES)];
	}

	if(paddedEncryptedMessage != NULL) {
		free(paddedEncryptedMessage);
	}
	if(paddedDecryptedMessage != NULL) {
		free(paddedDecryptedMessage);
	}
	
	return ret;
}
@end
