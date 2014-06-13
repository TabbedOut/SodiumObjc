# libsodium-objc

Objective-C bindings for [NaCL](http://nacl.cr.yp.to).

## Usage

### Public-Key Cryptography

Both `NSString` and `NSData` have been augmented with public-key encryption/decryption
methods via the `NSString+Nacl` and `NSData+NACL` categories.

#### Encryption

    NSString *plainText = @"I am about to get encrypted.";
    NACLCryptoKeyPair *sendersKeyPair = [NACLCryptoKeyPair keyPair];
    NACLCryptoKeyPair *receiversKeyPair = [NACLCryptoKeyPair keyPair];
    NACLNonce *nonce = [NACLNonce nonce];

    NSData *encryptedData;
    encryptedData = [plainText encryptedDataUsingPublicKey:sendersKeyPair.publicKey
                                                 secretKey:receiversKeyPair.secretKey
                                                     nonce:nonce];


#### Decryption

    plainText = [encryptedData decryptedTextUsingPublicKey:receiversKeyPair.publicKey
                                                 secretKey:sendersKeyPair.secretKey
                                                     nonce:nonce];
### Secret-Key Cryptography

Both `NSString` and `NSData` have been augmented with secret-key encryption/decryption
methods via the `NSString+Nacl` and `NSData+NACL` categories, as well.

#### Encryption

    NSString *plainText = @"I am about to get encrypted.";
    NACLSecretKey *secretKey = [NACLSecretKey secretKey];
    NACLNonce *nonce = [NACLNonce nonce];

    NSData *encryptedData;
    encryptedData = [plainText encryptedDataUsingSecretKey:secretKey nonce:nonce];

#### Decryption

    plainText = [encryptedData encryptedDataUsingSecretKey:secretKey nonce:nonce];

### Signatures

Both `NSString` and `NSData` have been augmented with signing methods via the
`NSString+Nacl` and `NSData+NACL` categories.

#### Signing

    NSString *plainText = @"I am about to get encrypted.";
    NACLSigningKeyPair *signingKeyPair = [NACLSigningKeyPair keyPair];
    NACLNonce *nonce = [NACLNonce nonce];

    NSData *signedData;
    signedData = [plainText signedDataUsingSecretKey:signingKeyPair.secretKey];

#### Verifying

    NSString *verifiedText;
    verifiedText = [signedData verifiedTextUsingPublicKey:signingKeyPair.publicKeyPair];
