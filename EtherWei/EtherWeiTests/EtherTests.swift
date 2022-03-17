//
//  EtherWeiTests.swift
//  EtherWeiTests
//
//  Created by hanwe on 2022/03/11.
//

import XCTest
@testable import EtherWei

class EtherTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testMulti() throws {
        let value1 = Ether("3.3")
        XCTAssertEqual(value1.multiple(rate: "0.3"), Ether("0.99"))
    }
    
    func testEtherToWei1() throws {
        let value: Ether = Ether("300")
        XCTAssertEqual(value.toWei(), Wei("300000000000000000000"))
    }
    
    func testEtherToWei2() throws {
        let value: Ether = Ether("0.1")
        XCTAssertEqual(value.toWei(), Wei("100000000000000000"))
    }
    
    func testEtherToWei3() throws {
        let value: Ether = Ether("3.1")
        XCTAssertEqual(value.toWei(), Wei("3100000000000000000"))
    }
    
    func testToDigitBelow1() throws {
        let value: Ether = Ether("3.333")
        XCTAssertEqual(value.toDigitBelow(3), "3.333")
    }
    
    func testToDigitBelow2() throws {
        let value: Ether = Ether("3.33343555577777")
        XCTAssertEqual(value.toDigitBelow(6), "3.333435")
    }
    
    func testToDigitBelow3() throws {
        let value: Ether = Ether("0.33343555577777")
        XCTAssertEqual(value.toDigitBelow(6), "0.333435")
    }
    
    func testToDigitBelow4() throws {
        let value: Ether = Ether("131313130.33343555577777")
        XCTAssertEqual(value.toDigitBelow(6), "131313130.333435")
    }
    
    func testIsZero1() throws {
        let value: Ether = Ether("0")
        XCTAssertTrue(value.isZero)
    }
    
    func testIsZero2() throws {
        let value: Ether = Ether("00000")
        XCTAssertTrue(value.isZero)
    }
    
    func testGrater() throws {
        let value1: Ether = Ether("1.2")
        let value2: Ether = Ether("1")
        XCTAssertTrue(value1 > value2)
    }
    
    func testGrater2() throws {
        let value1: Ether = Ether("1.2")
        let value2: Ether = Ether("1.5")
        XCTAssertTrue(value1 < value2)
    }
    
    func testGraterEqual1() throws {
        let value1: Ether = Ether("1.2")
        let value2: Ether = Ether("1.2")
        XCTAssertTrue(value1 >= value2)
    }
    
    func testGraterEqual2() throws {
        let value1: Ether = Ether("1.2")
        let value2: Ether = Ether("1.1")
        XCTAssertTrue(value1 >= value2)
    }
    
    func testGraterEqual3() throws {
        let value1: Ether = Ether("1.2")
        let value2: Ether = Ether("1.5")
        XCTAssertTrue(value1 <= value2)
    }
    
    func testGraterEqual4() throws {
        let value1: Ether = Ether("1.5")
        let value2: Ether = Ether("1.5")
        XCTAssertTrue(value1 <= value2)
    }
    
    

}
