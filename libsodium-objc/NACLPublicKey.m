//
//  NACLPublicKey.m
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 Tabbedout. All rights reserved.
//

#import "NACLPublicKey.h"

@implementation NACLPublicKey

+ (void)initialize {
	[NACL initialize];
	[super initialize];
}

- (id)init {
	unsigned char *keyBuffer = calloc(crypto_box_PUBLICKEYBYTES, sizeof(unsigned char));
	randombytes_buf(keyBuffer, crypto_box_PUBLICKEYBYTES);
	self = [super initWithBytesNoCopy:keyBuffer length:crypto_box_PUBLICKEYBYTES freeWhenDone:YES];
	if(self == nil){
		free(keyBuffer);
	}
	return self;
}

- (id)initWithKey:(NSData*)key {
	if(key.length != crypto_box_PUBLICKEYBYTES) {
		return nil;
	} else {
		return [super initWithData:key];
	}
}

@end
