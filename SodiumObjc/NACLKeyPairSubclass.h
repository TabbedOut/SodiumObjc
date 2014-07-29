//
//  NACLKeyPairSubclass.h
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/16/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLKeyPair.h"

OBJC_EXPORT NSString *const NACLKeyPairPrivateKeyCodingKey;
OBJC_EXPORT NSString *const NACLKeyPairPublicKeyCodingKey;

@interface NACLKeyPair (Subclass)
@property (strong, nonatomic, readwrite) NACLKey *publicKey;
@property (strong, nonatomic, readwrite) NACLKey *privateKey;

- (NSError *)errorForKeychainErrorCode:(OSStatus)errorCode;

@end