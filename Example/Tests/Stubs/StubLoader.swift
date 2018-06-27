//
//  StubLoader.swift
//  Keystore_Example
//
//  Created by Koray Koska on 27.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Quick
import Nimble
import Foundation

public extension QuickSpec {

    func loadStub(named: String) -> Data? {
        #if os(Linux) || os(FreeBSD)
        let path = "Tests/KeystoreTests/Stubs/\(named).json"
        let url = URL(fileURLWithPath: path)
        return try? Data(contentsOf: url)
        #else
        let bundle = Bundle(for: type(of: self))

        if let path = bundle.path(forResource: named, ofType: "json") {
            // XCTest
            let url = URL(fileURLWithPath: path)
            return try? Data(contentsOf: url)
        } else {
            let path = "Tests/KeystoreTests/Stubs/\(named).json"
            let url = URL(fileURLWithPath: path)
            return try? Data(contentsOf: url)
        }
        #endif
    }
}
