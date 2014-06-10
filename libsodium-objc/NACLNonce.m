//
//  NACLNonce.m
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 Tabbedout. All rights reserved.
//

#import "NACLNonce.h"

@implementation NACLNonce
+ (void)initialize {
	[NACL initialize];
	[super initialize];
}

- (id)init {
	unsigned char noncebuf[crypto_box_NONCEBYTES];
	randombytes_buf(noncebuf, crypto_box_NONCEBYTES);
	self = [super initWithBytes:noncebuf length:crypto_box_NONCEBYTES];
	return self;
}

- (id)initWithNonce:(NSData *)nonce {
	if(nonce.length != crypto_box_NONCEBYTES) {
		return nil;
	} else {
		return [super initWithData:nonce];
	}
}

- (id)initWithTimestamp {
	unsigned char noncebuf[crypto_box_NONCEBYTES];
	randombytes_buf(noncebuf, crypto_box_NONCEBYTES);
	time_t currTime = time(NULL);
	memcpy(noncebuf, &currTime, MIN(sizeof(time_t), crypto_box_NONCEBYTES / 2));
	self = [super initWithBytes:noncebuf length:crypto_box_NONCEBYTES];
	return self;
}

@end
