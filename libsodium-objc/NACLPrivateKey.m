//
//  NACLPrivateKey.m
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 Tabbedout. All rights reserved.
//

#import "NACLPrivateKey.h"

@implementation NACLPrivateKey
+ (void)initialize {
	[NACL initialize];
	[super initialize];
}

- (id)init {
	unsigned char privateKey[crypto_box_SECRETKEYBYTES];
	unsigned char publicKey[crypto_box_PUBLICKEYBYTES];
	crypto_box_keypair(publicKey, privateKey);
	
	self = [super initWithBytes:privateKey length:crypto_box_SECRETKEYBYTES];
	if(self){
		NSData* wrappedPublicKey = [NSData dataWithBytes:publicKey length:crypto_box_PUBLICKEYBYTES];
		_publicKey = [[NACLPublicKey alloc] initWithKey:wrappedPublicKey];
	}
	return self;
}

- (id)initWithSeed:(NSData*)seed {
	if(seed.length != crypto_box_SEEDBYTES) {
		return nil;
	}

	unsigned char privateKey[crypto_box_SECRETKEYBYTES];
	unsigned char publicKey[crypto_box_PUBLICKEYBYTES];
	crypto_box_seed_keypair(publicKey, privateKey, seed.bytes);
	
	self = [super initWithBytes:privateKey length:crypto_box_PUBLICKEYBYTES];
	if(self){
		NSData* wrappedPublicKey = [NSData dataWithBytes:publicKey length:crypto_box_PUBLICKEYBYTES];
		_publicKey = [[NACLPublicKey alloc] initWithKey:wrappedPublicKey];
	}
	return self;
}

@end
