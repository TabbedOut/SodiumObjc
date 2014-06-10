//
//  NACLVerifyKey.m
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 Tabbedout. All rights reserved.
//

#import "NACLVerifyKey.h"

@implementation NACLVerifyKey
+ (void)initialize {
	[super initialize];
	[NACL initialize];
}

- (id)init {
	unsigned char keyBuffer[crypto_sign_PUBLICKEYBYTES];
	randombytes_buf(keyBuffer, crypto_sign_PUBLICKEYBYTES);
	self = [super initWithBytes:keyBuffer length:crypto_sign_PUBLICKEYBYTES];
	return self;
}

- (id)initWithKey:(NSData*)key {
	if(key.length != crypto_sign_PUBLICKEYBYTES) {
		return nil;
	} else {
		return [super initWithData:key];
	}
}


- (NSData*)verify:(NSData*)signedData error:(NSError**)error {
	if(self.length != crypto_sign_PUBLICKEYBYTES) {
		WRAP_NSERROR(error, [NSError errorWithDomain:@"VerifyError" code:NACL_VERIFY_KEY_LENGTH userInfo:nil]);
		return nil;
	}
	
	if(signedData.length < crypto_sign_BYTES) {
		WRAP_NSERROR(error, [NSError errorWithDomain:@"VerifyError" code:NACL_VERIFY_SIGNED_DATA_LENGTH userInfo:nil])
		return nil;
	}

	unsigned long bufLen = signedData.length - crypto_sign_BYTES;
	unsigned long long verificationLength = 0;
	unsigned char* messageBuffer = calloc(bufLen, sizeof(unsigned char));
	if(messageBuffer == NULL){
		WRAP_NSERROR(error, [NSError errorWithDomain:@"VerifyError" code:NACL_VERIFY_ALLOCATION_ERROR userInfo:nil]);
		return nil;
	}
	
	if(crypto_sign_open(messageBuffer, &verificationLength, signedData.bytes, signedData.length, self.bytes) != 0) {
		free(messageBuffer);
		WRAP_NSERROR(error, [NSError errorWithDomain:@"VerifyError" code:NACL_VERIFY_FAILED userInfo:nil])
		return nil;
	} else {
		return [NSData dataWithBytesNoCopy:messageBuffer length:(signedData.length - crypto_sign_BYTES) freeWhenDone:YES];
	}
}
@end
