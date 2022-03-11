//
//  WeiTests.swift
//  EtherWeiTests
//
//  Created by hanwe on 2022/03/11.
//

import XCTest
@testable import EtherWei

class WeiTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testWeiToEther1() throws {
        let value: Wei = Wei("1000000000000000000")
        XCTAssertEqual(value.toEther(), Ether("1"))
    }
    
    func testWeiToEther2() throws {
        let value: Wei = Wei("1030000000000000000")
        XCTAssertEqual(value.toEther(), Ether("1.03"))
    }
    
    func testWeiToEther3() throws {
        let value: Wei = Wei("30000000000000000")
        XCTAssertEqual(value.toEther(), Ether("0.03"))
    }
    
    func testIsZero1() throws {
        let value: Wei = Wei("0")
        XCTAssertTrue(value.isZero)
    }
    
    func testIsZero2() throws {
        let value: Wei = Wei("0.000000000000000000000000000000")
        XCTAssertTrue(value.isZero)
    }
    

}
