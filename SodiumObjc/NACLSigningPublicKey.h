//
//  NACLSigningPublicKey.h
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <SodiumObjc/NACLKey.h>

@interface NACLSigningPublicKey : NACLKey

- (NSString *)verifiedTextFromSignedData:(NSData *)data;
- (NSString *)verifiedTextFromSignedData:(NSData *)data error:(NSError **)outError;

- (NSData *)verifiedDataFromSignedData:(NSData *)data;
- (NSData *)verifiedDataFromSignedData:(NSData *)data error:(NSError **)outError;

+ (NSUInteger)signatureLength;

@end
