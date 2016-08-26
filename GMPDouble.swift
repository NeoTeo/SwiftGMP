//
//  GMPDouble.swift
//  SwiftGMP
//
//  Created by twodayslate on 8/26/16.
//  Copyright © 2016 Teo. All rights reserved.
//

import Foundation
import GMP

// Multiple-precision Floating-point
public class GMPDouble : Equatable, Comparable {
    private var d : mpf_t
    private var inited : Bool = false;
    
    public init() {
        d = mpf_t()
        __gmpf_init(&d);
        inited = true
    }
    
    public convenience init(_ x : Double) {
        self.init()
        let y = CDouble(x)
        if Double(y) == x {
            __gmpf_set_d(&d, y)
        } else {
            // something went wrong
        }
    }
    
    public convenience init(_ str : String) {
        self.init();
        __gmpf_set_str(&d, (str as NSString).utf8String, 10)
        
    }
    
    deinit {
        if(self.inited) {
            __gmpf_clear(&d)
            self.inited = false
        }
    }
    
    // Return non-zero if an integer.
    public func isInteger() -> Int32 {
        var x = d
        return __gmpf_integer_p(&x)
    }

    public static func add(_ a : GMPDouble, _ b : GMPDouble) -> GMPDouble {
        let x = a, y = b;
        let c = GMPDouble()
        __gmpf_add(&c.d, &x.d, &y.d)
        return c
    }

    public static func sub(_ a: GMPDouble, _ b: GMPDouble) -> GMPDouble {
        let x = a, y = b;
        let c = GMPDouble() //self
        __gmpf_sub(&c.d, &x.d, &y.d)
        return c
    }

    public static func mul(_ x: GMPDouble, _ y: GMPDouble) -> GMPDouble {
        let a = x
        let b = y
        let c = GMPDouble() //self
        __gmpf_mul(&c.d, &a.d, &b.d)
        return c
    }

    public static func div(_ x: GMPDouble, _ y: GMPDouble) -> GMPDouble {
        let a = x
        let b = y
        let c = GMPDouble() //self
        __gmpf_div(&c.d, &a.d, &b.d)
        return c
    }

    public static func floor(_ x: GMPDouble) -> GMPDouble {
        let a = x
        let b = GMPDouble()
        __gmpf_floor(&b.d, &a.d)
        return b
    }

    public static func ceil(_ x: GMPDouble) -> GMPDouble {
        let a = x
        let b = GMPDouble()
        __gmpf_ceil(&b.d, &a.d)
        return b
    }

    // Cmp compares x and y and returns:
    //
    //   -1 if x <  y
    //    0 if x == y
    //   +1 if x >  y
    public static func cmp(_ number: GMPDouble, _ y: GMPDouble) -> Int {
        let xl = number
        let yl = y
        return Int(__gmpf_cmp(&xl.d, &yl.d))
    }

    private static func inBase(_ number: GMPDouble, _ base: Int) -> String {
        var ti = number.d
        var ex : Int = Int(mp_exp_t()) as Int // this is the deimal place
        let p = __gmpf_get_str(nil, &ex, CInt(base), 0, &ti)
        var s = String(cString: p!)
        
        let isNegative = s.characters.first == "-" ? 1 : 0;
        
        //print("ex:" + String(ex) + " count: " + String(s.characters.count) + " isNegative: " + String(isNegative))
        
        if(ex < s.characters.count - isNegative) {
            // add the decimal character to the floating point
            let si = s.index(s.startIndex, offsetBy: ex + isNegative)
            s.insert(".", at: si)
        } else {
            // add padding
            for _ in 0..<(ex - s.characters.count + isNegative) {
                s.append("0")
            }
        }
        
        return s
    }

    public static func string(_ number: GMPDouble) -> String {
        return self.inBase(number, 10)
    }
    
    public var description : String {
        return GMPDouble.string(self)
    }
    
}

public func + (_ a : GMPDouble, _ b : GMPDouble) -> GMPDouble {
    return GMPDouble.add(a, b)
}
public func - (_ a : GMPDouble, _ b : GMPDouble) -> GMPDouble {
    return GMPDouble.sub(a, b)
}
public func * (_ a : GMPDouble, _ b : GMPDouble) -> GMPDouble {
    return GMPDouble.mul(a, b)
}
public func / (_ a : GMPDouble, _ b : GMPDouble) -> GMPDouble {
    return GMPDouble.div(a, b)
}
public func == (_ a : GMPDouble, _ b : GMPDouble) -> Bool {
    return GMPDouble.cmp(a, b) == 0 ? true : false
}
public func < (_ a : GMPDouble, _ b : GMPDouble) -> Bool {
    return GMPDouble.cmp(a, b) < 0 ? true : false
}
