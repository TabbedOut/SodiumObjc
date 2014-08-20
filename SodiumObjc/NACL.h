//
//  NACL.h
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXPORT NSString *const NACLErrorDomain;

typedef NS_ENUM(NSUInteger, NACLErrorCode) {
    NACLErrorInvalidPrivateKeyLengthCode = 1,
    NACLErrorInvalidPublicKeyLengthCode,
    NACLErrorInvalidNonceLengthCode,
    NACLErrorInvalidMessageLengthCode,
    NACLErrorAllocationErrorCode,
    NACLErrorFailureCode,
    NACLErrorInvalidNonceCode,
};

@interface NACL : NSObject

+ (void)initializeNACL;

@end
