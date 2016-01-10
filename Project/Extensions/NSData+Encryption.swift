//
//  NSData+Encryption.swift
//  EPICEncryption
//
//  Created by Danny Bravo on 27/10/2015.
//  Copyright © 2015 EPIC. All rights reserved.
//

import Foundation

//MARK: - error types
/// this enumeration contains a list of possible errors than can occur when encrypting or decrypting a data object using the EPICEncryption extension
enum EPICDataCryptographyError : ErrorType {
    
    /// Error specifying that the passed key is invalid and cannot be used to encrypt the data, normally happens then the key is empty
    case InvalidKey
    
    /// Error thrown when an encryption could not be made due to an unknown error
    case CouldNotEncrypt
    
    /// Error thrown when an decryption could not be made due the key being incorrect
    case CouldNotDecrypt
}

extension NSData {
    
    //MARK: - cryptographic utilities
    /**
     Encrypts the content of an NSData object using AES128 encryption with the specified key passed as a parameter.
     - parameter key: the key used as a salt for encrypting the data
     - returns: the encrypted data or a thrown error if the data cannot be encrypted
     */
    func encryptUsingKey(key: String) throws -> NSData {
        return try self.cryptWithOperation(UInt32(kCCEncrypt), key: key)
    }
    
    /**
     Decrypts previously encrypted NSData objects using AES128 decryption with the specified key passed as a parameter.
     - parameter key: the key that was originally used as a salt for encrypting the data
     - returns: the decrypted data or a thrown error if the data cannot be decrypted
     */
    func decryptUsingKey(key: String) throws -> NSData {
        return try self.cryptWithOperation(UInt32(kCCDecrypt), key: key)
    }
    
    //MARK: - private utilities
    private func cryptWithOperation(operation: CCOperation, key: String) throws -> NSData {
        guard key.characters.count > 0 else {
            print("You cannot encrypt data with an empty key")
            throw EPICDataCryptographyError.InvalidKey
        }
        if let keyData = key.dataUsingEncoding(NSUTF8StringEncoding) {
            let keyBytes = UnsafeMutablePointer<Void>(keyData.bytes)
            
            let dataLength = size_t(self.length)
            let dataBytes = UnsafeMutablePointer<Void>(self.bytes)
            
            if let cryptData = NSMutableData(length: Int(dataLength) + kCCBlockSizeAES128) {
                let cryptPointer = UnsafeMutablePointer<Void>(cryptData.mutableBytes)
                let cryptLength = size_t(cryptData.length)
                
                let keyLength = size_t(kCCKeySizeAES256)
                let algoritm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
                let options: CCOptions = UInt32(kCCOptionPKCS7Padding + kCCOptionECBMode)
                
                var numBytesEncrypted :size_t = 0
                let cryptStatus = CCCrypt(operation, algoritm, options, keyBytes, keyLength, nil, dataBytes, dataLength, cryptPointer, cryptLength, &numBytesEncrypted)
                if UInt32(cryptStatus) == UInt32(kCCSuccess) {
                    cryptData.length = Int(numBytesEncrypted)
                    return cryptData
                }
                print("Encryption error: CCCrypt function status code: \(cryptStatus)")
            }
        }
        throw EPICDataCryptographyError.CouldNotEncrypt
    }
    
}