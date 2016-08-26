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
        let a = SwiftGMP.GMPDouble("12334525234523452354.134534534")
        let b = SwiftGMP.GMPDouble(12341.8233)
        let c = SwiftGMP.GMPDouble(100.00)
        let d = SwiftGMP.GMPDouble(-10.00)
        let e = SwiftGMP.GMPDouble(-1.002)
        
        print("a: \(SwiftGMP.GMPDouble.string(a))")
        print("b: \(SwiftGMP.GMPDouble.string(b))")
        print("c: \(SwiftGMP.GMPDouble.string(c))")
        print("d: \(SwiftGMP.GMPDouble.string(d))")
        print("e: \(SwiftGMP.GMPDouble.string(e))")
        
        XCTAssert(c.isInteger() != 0, "c is an integer")
        XCTAssert(d.isInteger() != 0, "d is an integer")
        
        let f = SwiftGMP.GMPDouble(10.6)
        let g = SwiftGMP.GMPDouble(2.1)
        
        print("f: \(SwiftGMP.GMPDouble.string(f))")
        print("g: \(SwiftGMP.GMPDouble.string(g))")
        
        print("f > g: " + String(f>g))
        
        let h = SwiftGMP.GMPDouble.cmp(f, g)
        print("h: " + String(h) + " " + String(f==g))
        XCTAssert(h > 0, " c is greater than d")
        
        let i = SwiftGMP.GMPDouble.add(f, g)
        print("i (f+g): \(SwiftGMP.GMPDouble.string(i)) " + SwiftGMP.GMPDouble.string(f+g))
        
        let j = SwiftGMP.GMPDouble.sub(f, g)
        print("j (f+g): \(SwiftGMP.GMPDouble.string(j)) " + SwiftGMP.GMPDouble.string(f-g))
        
        let k = SwiftGMP.GMPDouble.mul(f, g)
        print("k (f*g): \(SwiftGMP.GMPDouble.string(k)) " + SwiftGMP.GMPDouble.string(f*g))
        
        let l = SwiftGMP.GMPDouble.div(f, g)
        print("l (f/g): \(SwiftGMP.GMPDouble.string(l)) " + SwiftGMP.GMPDouble.string(f/g))
        
        let m = SwiftGMP.GMPDouble.floor(f)
        print("m (floor(f)): \(SwiftGMP.GMPDouble.string(m))")
        
        let n = SwiftGMP.GMPDouble.ceil(f)
        print("n (ceil(f)): \(SwiftGMP.GMPDouble.string(n))")
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
