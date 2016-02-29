# EPICEncryption

EPICEncryption is a category extension on NSData written in swift that for encryption and decryption of data using a String key. Data is encrypted using a AES128 algorithm. Trying to encrypt data using an invalid key (i.e: zero length String), or trying to decrypt data using the wrong key, will throw an error.

#### Usage:
```swift
var data : NSData = ...some data...
data = data.encryptUsingKey("some super secret key string") //data is now encrypted and cannot be read
data = decryptUsingKey("some super secret key string") // data is now decrypted back into its original state
```

Usage is free for all based on the attached license details, if you find this code useful, please consider [letting me know](helloworld@epic-apps.uk)! :)

Copyright (c) EPIC 
[www.epic-apps.uk](www.epic-apps.uk)
