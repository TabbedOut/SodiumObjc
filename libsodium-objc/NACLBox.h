//
//  NACLBox.h
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 Tabbedout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NACL.h"
#import "NACLPrivateKey.h"
#import "NACLPublicKey.h"
#import "NACLNonce.h"

enum {
	NACL_BOX_SECRET_LENGTH = 1,
	NACL_BOX_PUBLIC_LENGTH,
	NACL_BOX_NONCE_LENGTH,
	NACL_BOX_MESSAGE_LENGTH,
	NACL_BOX_ALLOCATION_ERROR,
	NACL_BOX_FAILED,
	NACL_BOX_INVALID_NONCE
};

@interface NACLBox : NSObject
+ (NSData*)encryptMessage:(NSData*)message
			  withPrivate:(NACLPrivateKey*)privateKey
				   public:(NACLPublicKey*)publicKey
				 andNonce:(NACLNonce*)nonce
					error:(NSError**)error;

+ (NSData*)decryptMessage:(NSData*)encryptedMessage
			  withPrivate:(NACLPrivateKey*)privateKey
				   public:(NACLPublicKey*)publicKey
					nonce:(NACLNonce**)nonce
					error:(NSError**)error;
@end
