//
//  NSDataEncryptionTests.swift
//  EPICEncryption
//
//  Created by Danny Bravo on 11/11/2015.
//  Copyright © 2015 EPIC. All rights reserved.
//

import XCTest
@testable import EPICEncryption

//MARK: - constants
private let KEY = "87734uhaf87hoagaywg8732ghwega8763gugwhjweg823o78g3ayfgawegf87a2ghfa2egj"
private let BAD_KEY = ""
private let WRONG_KEY = "87734uhaf87hoagaywg8732ghwega8763gugwhjweg823o78g3ayfgawegf87a2ghfa2egj"

private let ORIGINAL_STRING = "testing with £™¡ complex characters 😈"

class NSDataEncryptionTests: XCTestCase {

    func testCryptography() {
        let string = "testing with £™¡ complex characters 😈"
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            
            // BAD KEY ENCRYPTION CHECK
            do {
                try data.encryptUsingKey(BAD_KEY)
            } catch let error as EPICDataCryptographyError {
                XCTAssertEqual(error, EPICDataCryptographyError.InvalidKey)
            } catch {
                XCTFail()
            }
            
            // GOOD ENCRYPTION CHECK
            do {
                let encryptedData = try data.encryptUsingKey(KEY)
                XCTAssertNotEqual(encryptedData, data)
                XCTAssertNil(String(data: encryptedData, encoding: NSUTF8StringEncoding))
                
                // BAD KEY ENCRYPTION CHECK
                do {
                    try encryptedData.decryptUsingKey(BAD_KEY)
                } catch let error as EPICDataCryptographyError {
                    XCTAssertEqual(error, EPICDataCryptographyError.InvalidKey)
                } catch {
                    XCTFail()
                }
                
                // BAD KEY ENCRYPTION CHECK
                do {
                    try encryptedData.decryptUsingKey(WRONG_KEY)
                } catch let error as EPICDataCryptographyError {
                    XCTAssertEqual(error, EPICDataCryptographyError.CouldNotDecrypt)
                } catch {
                    XCTFail()
                }
                
                // GOOD DECRYPTION CHECK
                let decryptedData = try encryptedData.decryptUsingKey(KEY)
                XCTAssertEqual(decryptedData, data)
                
            } catch {
                XCTFail("error: \(error)")
            }
        } else {
            XCTFail()
        }
    }

}
