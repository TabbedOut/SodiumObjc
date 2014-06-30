//
//  NACLAsymmetricPrivateKey.m
//  libsodium-objc
//
//  Created by Damian Carrillo on 6/13/14.
//  Copyright (c) 2014 TabbedOut. All rights reserved.
//

#import <Security/Security.h>
#import "NACLAsymmetricPrivateKey.h"
#import "NACL.h"
#import "NACLKeySubclass.h"

@implementation NACLAsymmetricPrivateKey

+ (void)initialize 
{
	[NACL initializeNACL];
	[super initialize];
}

+ (instancetype)key
{
    NSAssert(NO, @"Rely on NACLAsymmetricKeyPair to create a NACLAsymmetricKey with correct data");
    return nil;
}

+ (instancetype)keyWithData:(NSData *)keyData
{
    NSAssert(NO, @"Rely on NACLAsymmetricKeyPair to create a NACLAsymmetricKey with correct data");
    return nil;
}

+ (NSUInteger)keyLength
{
    return crypto_box_SECRETKEYBYTES;
}

- (instancetype)init
{
    NSAssert(NO, @"Rely on NACLAsymmetricKeyPair to create a NACLAsymmetricKey with correct data");
    return nil;
}

- (NSData *)generateDefaultKeyData
{
    // Rely on NACLAsymmetricKeyPair to create this with correct data
    
    return nil;
}

- (BOOL)storeInKeychainWithApplicationLabel:(NSString *)applicationlabel
                                      error:(NSError *__autoreleasing *)outError
{
    NSData *encodedKeyData = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    if ([encodedKeyData length] == 0) {
        return NO;
    }
    
    // Prepare the query
    
    CFMutableDictionaryRef keychainQuery = CFDictionaryCreateMutable(NULL,
                                                                     0,
                                                                     &kCFTypeDictionaryKeyCallBacks,
                                                                     &kCFTypeDictionaryValueCallBacks);
    CFDictionaryAddValue(keychainQuery, kSecClass, kSecClassKey);
    CFDictionaryAddValue(keychainQuery, kSecReturnAttributes, kCFBooleanTrue);
    CFDictionaryAddValue(keychainQuery, kSecAttrKeyClass, kSecAttrKeyClassPrivate);
    CFDictionaryAddValue(keychainQuery, kSecAttrIsPermanent, kCFBooleanTrue);
    
    // Conditionally query on the application label if one is supplied
    
    if (applicationlabel.length > 0) {
        CFDictionaryAddValue(keychainQuery, kSecAttrApplicationLabel, (__bridge const void *)(applicationlabel));
    }
    
    CFTypeRef storedKeyData = NULL;
    OSStatus err = SecItemCopyMatching(keychainQuery, &storedKeyData);
    
    if (err == errSecItemNotFound) {
        
        // Create the entry
        
        CFDictionaryRemoveValue(keychainQuery, kSecReturnAttributes);
        CFDictionaryAddValue(keychainQuery, kSecValueData, (__bridge const void *)(encodedKeyData));
        SecItemAdd(keychainQuery, NULL);
    } else if (err == noErr) {
        NSData *storedEncodedKeyData = (__bridge NSData *)(storedKeyData);
        
        if (![storedEncodedKeyData isEqualToData:encodedKeyData]) {
            
            // Update the entry if the data has changed

            CFDictionaryRemoveValue(keychainQuery, kSecReturnAttributes);
            CFDictionaryAddValue(keychainQuery, kSecValueData, (__bridge const void *)(encodedKeyData));
            SecItemUpdate(keychainQuery, NULL);
        }
    } else if (outError) {
        *outError = [self errorForKeychainErrorCode:err];
    }
    
    return err == noErr;
}

@end
