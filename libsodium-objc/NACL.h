//
//  NACL.h
//  libsodium-objc
//
//  Created by Philip Jameson on 6/10/14.
//  Copyright (c) 2014 Tabbedout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sodium.h"

#define WRAP_NSERROR(ptr, newError) { if(ptr != NULL){ *ptr = newError; } }

@interface NACL : NSObject

@end
