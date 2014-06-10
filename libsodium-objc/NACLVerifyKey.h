//
//  NACLVerifyKey.h
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 Tabbedout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NACL.h"
#import "sodium.h"

enum {
	NACL_VERIFY_KEY_LENGTH = 1,
	NACL_VERIFY_SIGNED_DATA_LENGTH,
	NACL_VERIFY_FAILED,
	NACL_VERIFY_ALLOCATION_ERROR
};

@interface NACLVerifyKey : NSData
- (id)init;
- (id)initWithKey:(NSData*)key;
- (NSData*)verify:(NSData*)signedData error:(NSError**)error;
@end
