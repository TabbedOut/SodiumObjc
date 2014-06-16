//
//  NACLKeyPairSubclass.h
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/16/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import "NACLKeyPair.h"

@interface NACLKeyPair (Subclass)
@property (strong, nonatomic, readwrite) NACLKey *publicKey;
@property (strong, nonatomic, readwrite) NACLKey *privateKey;
@end