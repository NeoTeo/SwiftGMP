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
        let b = DoubleBig(12341.8233)
        let c = DoubleBig(100.00)
        let d = DoubleBig(-10.00)
        let e = DoubleBig(-1.002)
        
        print("a: \(SwiftGMP.string(a))")
        print("b: \(SwiftGMP.string(b))")
        print("c: \(SwiftGMP.string(c))")
        print("d: \(SwiftGMP.string(d))")
        print("e: \(SwiftGMP.string(e))")
        
        XCTAssert(c.isInteger() != 0, "c is an integer")
        XCTAssert(d.isInteger() != 0, "d is an integer")
        
        let f = DoubleBig(10.6)
        let g = DoubleBig(2.1)
        
        print("f: \(SwiftGMP.string(f))")
        print("g: \(SwiftGMP.string(g))")
        
        let h = SwiftGMP.cmp(f, g)
        print("h: " + String(h))
        XCTAssert(h > 0, " c is greater than d")
        
        let i = SwiftGMP.add(f, g)
        print("i (f+g): \(SwiftGMP.string(i))")
        
        let j = SwiftGMP.sub(f, g)
        print("j (f+g): \(SwiftGMP.string(j))")
        
        let k = SwiftGMP.mul(f, g)
        print("k (f*g): \(SwiftGMP.string(k))")
        
        let l = SwiftGMP.div(f, g)
        print("l (f/g): \(SwiftGMP.string(l))")
        
        let m = SwiftGMP.floor(f)
        print("m (floor(f)): \(SwiftGMP.string(m))")
        
        let n = SwiftGMP.ceil(f)
        print("n (ceil(f)): \(SwiftGMP.string(n))")
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
