//
//  NACLSigningKey.m
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 Tabbedout. All rights reserved.
//

#import "NACLSigningKey.h"

@implementation NACLSigningKey

+ (void)initialize {
	[super initialize];
	[NACL initialize];
}

- (id)init {
	unsigned char privateKey[crypto_sign_SECRETKEYBYTES];
	unsigned char publicKey[crypto_sign_PUBLICKEYBYTES];
	crypto_sign_keypair(publicKey, privateKey);
	
	self = [super initWithBytes:privateKey length:crypto_sign_SECRETKEYBYTES];
	if(self){
		NSData* publicKeyWrapped = [NSData dataWithBytes:publicKey length:crypto_sign_PUBLICKEYBYTES];
		_verifyKey = [[NACLVerifyKey alloc] initWithKey:publicKeyWrapped];
	}
	return self;
}

- (id)initWithSeed:(NSData*)seed {
	if(seed.length != crypto_sign_SEEDBYTES) {
		return nil;
	}
	
	unsigned char privateKey[crypto_sign_SECRETKEYBYTES];
	unsigned char publicKey[crypto_sign_PUBLICKEYBYTES];
	crypto_sign_seed_keypair(publicKey, privateKey, seed.bytes);
	
	self = [super initWithBytes:privateKey length:crypto_sign_SECRETKEYBYTES];
	if(self){
		NSData* publicKeyWrapped = [NSData dataWithBytes:publicKey length:crypto_sign_PUBLICKEYBYTES];
		_verifyKey = [[NACLVerifyKey alloc] initWithKey:publicKeyWrapped];
	}
	return self;
}

- (NSData*)sign:(NSData*)unsignedData error:(NSError **)error{
	if(self.length != crypto_sign_SECRETKEYBYTES) {
		WRAP_NSERROR(error, [NSError errorWithDomain:@"SigningError" code:NACL_SIGNING_KEY_LENGTH userInfo:nil]);
		return nil;
	}
	
	unsigned long signedBufferLength = crypto_sign_BYTES + unsignedData.length;
	unsigned long long signedLength = 0;
	unsigned char* signedBuffer = calloc(signedBufferLength, sizeof(unsigned char));
	if(signedBuffer == NULL){
		WRAP_NSERROR(error, [NSError errorWithDomain:@"SigningError" code:NACL_SIGNING_ALLOCATION_ERROR userInfo:nil]);
		return nil;
	}
	
	if(crypto_sign(signedBuffer, &signedLength, unsignedData.bytes, unsignedData.length, self.bytes) != 0){
		free(signedBuffer);
		WRAP_NSERROR(error, [NSError errorWithDomain:@"SigningError" code:NACL_SIGNING_FAILED userInfo:nil]);
		return nil;
	} else {
		return [NSData dataWithBytesNoCopy:signedBuffer length:signedBufferLength freeWhenDone:YES];
	}
}

@end
