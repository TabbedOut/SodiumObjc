# SodiumObjc

Objective-C bindings for [NaCL](http://nacl.cr.yp.to).

[![Build Status](https://travis-ci.org/Tabbedout/SodiumObjc.svg)](https://travis-ci.org/Tabbedout/SodiumObjc)

## License

[MIT License](https://tldrlegal.com/license/mit-license). See LICENSE for more information.

## Usage

### Public-Key Cryptography

Both `NSString` and `NSData` have been augmented with public-key encryption/decryption
methods via the `NSString+Nacl` and `NSData+NACL` categories.

#### Encryption

    NSString *plainText = @"I am about to get encrypted.";
    NACLAsymmetricKeyPair *sendersKeyPair = [NACLAsymmetricKeyPair keyPair];
    NACLAsymmetricKeyPair *receiversKeyPair = [NACLAsymmetricKeyPair keyPair];
    NACLNonce *nonce = [NACLNonce nonce];

    NSData *encryptedData;
    encryptedData = [plainText encryptedDataUsingPublicKey:sendersKeyPair.publicKey
                                                privateKey:receiversKeyPair.privateKey
                                                     nonce:nonce];


#### Decryption

    plainText = [encryptedData decryptedTextUsingPublicKey:receiversKeyPair.publicKey
                                                privateKey:sendersKeyPair.privateKey];

#### Compatibility

The methods that perform public-key encryption pack the nonce data at the beginning of the
encrypted data object. The methods that perform public-key decryption without an
explicit nonce argument expect nonce data to be packed at the beginning of the receiver.
The methods that perform public-key decryption with an explicit nonce argument expect
nonce data to not be packed at the beginning of the receiver. This behavior is provided as a
convenience so you don't have to maintain the nonce. Keep in mind that if you consume
encrypted data on another platform (or any library other than SodiumObjc), you should
remove the nonce.

    NSData *encryptedData;
    encryptedData = [[plainText encryptedDataUsingPublicKey:sendersKeyPair.publicKey
                                                 privateKey:receiversKeyPair.privateKey
                                                      nonce:nonce] dataWithoutNonce];

    NSMutableURLRequest *request = ...
    request.HTTPBody = encryptedData;

### Private-Key Cryptography

Both `NSString` and `NSData` have been augmented with secret-key encryption/decryption
methods via the `NSString+Nacl` and `NSData+NACL` categories, as well.

#### Encryption

    NSString *plainText = @"I am about to get encrypted.";
    NACLSymmetricPrivateKey *privateKey = [NACLSymmetricPrivateKey privateKey];
    NACLNonce *nonce = [NACLNonce nonce];

    NSData *encryptedData;
    encryptedData = [plainText encryptedDataUsingPrivateKey:privateKey nonce:nonce];

#### Decryption

    plainText = [encryptedData decryptedDataUsingPrivateKey:privateKey nonce:&nonce];

#### Compatibility

The methods that perform private-key encryption also pack the nonce data at the beginning of
the encrypted data object. The methods that perform private-key decryption without an
explicit nonce argument expect nonce data to be packed at the beginning of the receiver.
The methods that perform private-key decryption with an explicit nonce argument expect
nonce data to not be packed at the beginning of the receiver. This behavior is provided as a
convenience so you don't have to maintain the nonce. Keep in mind that if you consume
encrypted data on another platform (or any library other than SodiumObjc), you should
remove the nonce.

    NSData *encryptedData;
    encryptedData = [[plainText encryptedDataUsingPrivateKey:privateKey
                                                       nonce:nonce] dataWithoutNonce];

    NSMutableURLRequest *request = ...
    request.HTTPBody = encryptedData;

### Signatures

Both `NSString` and `NSData` have been augmented with signing methods via the
`NSString+Nacl` and `NSData+NACL` categories.

#### Signing

    NSString *plainText = @"I am about to get encrypted.";
    NACLSigningKeyPair *signingKeyPair = [NACLSigningKeyPair keyPair];
    NACLNonce *nonce = [NACLNonce nonce];

    NSData *signedData;
    signedData = [plainText signedDataUsingPrivateKey:signingKeyPair.privateKey];

#### Verifying

    NSString *verifiedText;
    verifiedText = [signedData verifiedTextUsingPublicKey:signingKeyPair.publicKeyPair];

## Building

Building libsodium consists of the following steps:

* Fetch the contents of the libsodium submodule
* Building libsodium for all involved architectures
* Copying the built archives and headers to the correct location

The steps that I use to do this are:

    git submodule update --init --recursive
    cd libsodium-darwin-build
    make clean all
    cp libsodium-ios.a ../lib/ios/
    cp libsodium-osx.a ../lib/osx/
    cp -R build/iPhoneOS-arm64/include ../lib/ios/
    cp -R build/MacOSX-x86_64/include ../lib/osx/
