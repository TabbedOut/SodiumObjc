//
//  NACLSigningPrivateKey.h
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLKey.h"

@interface NACLSigningPrivateKey : NACLKey

- (NSData *)signedDataFromText:(NSString *)text;
- (NSData *)signedDataFromText:(NSString *)text error:(NSError **)outError;

- (NSData *)signedDataFromData:(NSData *)data;
- (NSData *)signedDataFromData:(NSData *)data error:(NSError **)outError;

@end
