//
//  NACLKeySubclass.h
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLKey.h"

@interface NACLKey (Subclass)
@property (copy, nonatomic, readwrite) NSData *data;

- (instancetype)initWithData:(NSData *)keyData;
- (NSData *)generateDefaultKeyData;

@end
