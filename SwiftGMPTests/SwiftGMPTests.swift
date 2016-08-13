//
//  SwiftGMPTests.swift
//  SwiftGMPTests
//
//  Created by Teo on 21/05/15.
//  Copyright (c) 2015 Teo. All rights reserved.
//

//import Cocoa

import XCTest
import SwiftGMP

class SwiftGMPTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDouble() {
        let a = DoubleBig("12334525234523452354.134534534")
        let b = DoubleBig(12341.3233)
        let bb = DoubleBig(100.00)
        
        print("a: \(SwiftGMP.string(a))")
        print("b: \(SwiftGMP.string(b))")
        print("bb: \(SwiftGMP.string(bb))")
        
        let c = DoubleBig(10.5)
        let d = DoubleBig(2.1)
        
        print("c: \(SwiftGMP.string(c))")
        print("d: \(SwiftGMP.string(d))")
        
        let r = SwiftGMP.cmp(c, d)
        print("r: " + String(r))
        XCTAssert(r > 0, " c is greater than d")
        
        
        let e = SwiftGMP.add(c, d)
        print("e (c+d): \(SwiftGMP.string(e))")
        
        let f = SwiftGMP.sub(c, d)
        print("f (c-d): \(SwiftGMP.string(f))")
        
        let g = SwiftGMP.mul(c, d)
        print("g (c*d): \(SwiftGMP.string(g))")
    }
    
    func testInt() {
        let b = IntBig("246375425603637729")//.newIntBig(58)
        let c = IntBig(58)
        print("b: \(SwiftGMP.string(b))")
        
        XCTAssert(SwiftGMP.cmp(b,c) != 0, "compare error")
        
        print("Bytes: \(SwiftGMP.bytes(b))")
        
        var d = SwiftGMP.mul(b, c)
        print("mul: \(SwiftGMP.string(d))")
        
        d = SwiftGMP.add(b, c)
        print("add: \(SwiftGMP.string(d))")
        var e = IntBig(69)
        e = IntBig(42)
        print("e = \(SwiftGMP.string(e))")
        let n = SwiftGMP.getInt64(e)
        print("n = \(n!)")
        XCTAssert(n == 42, "Pass")
    }
    
    func testAll() {
        // This is an example of a functional test case.
        testInt()
        
        testDouble()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
