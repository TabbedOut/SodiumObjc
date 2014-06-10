//
//  NACLSigningKey.h
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 Tabbedout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NACL.h"
#import "NACLVerifyKey.h"

enum {
	NACL_SIGNING_KEY_LENGTH = 1,
	NACL_SIGNING_FAILED,
	NACL_SIGNING_ALLOCATION_ERROR
};

@interface NACLSigningKey : NSData
@property (strong, nonatomic, readonly) NACLVerifyKey* verifyKey;

- (id)init;
- (id)initWithSeed:(NSData*)seed;
- (NSData*)sign:(NSData*)unsignedData error:(NSError**)error;
@end
