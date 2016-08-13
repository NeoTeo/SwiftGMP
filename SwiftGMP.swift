//
//  SwiftGMP.swift
//  SwiftGMP
//
//  Created by Teo on 21/05/15.
//  Copyright (c) 2015 Teo. All rights reserved.
//

import Foundation
import GMP

// Multiple-precision Floating-point
public struct DoubleBig {
    var d : mpf_t
    var inited : Bool = false;
    
    public init() {
        d = mpf_t()
        __gmpf_init(&d);
        inited = true
    }
}

extension DoubleBig {
    public init(_ x : Double) {
        self.init()
        let y = CDouble(x)
        if Double(y) == x {
            __gmpf_set_d(&d, y)
        } else {
            // something went wrong
        }
    }
    
    public init(_ str : String) {
        self.init();
        __gmpf_set_str(&d, (str as NSString).utf8String, 10)
        
    }
    
    public mutating func finalize() {
        if(self.inited) {
            __gmpf_clear(&d)
        }
    }
}

public func add(_ a : DoubleBig, _ b : DoubleBig) -> DoubleBig {
    var x = a, y = b;
    var c = DoubleBig()
    __gmpf_add(&c.d, &x.d, &y.d)
    return c
}

public func sub(_ a: DoubleBig, _ b: DoubleBig) -> DoubleBig {
    var x = a, y = b;
    var c = DoubleBig() //self
    __gmpf_sub(&c.d, &x.d, &y.d)
    return c
}

// Cmp compares x and y and returns:
//
//   -1 if x <  y
//    0 if x == y
//   +1 if x >  y
public func cmp(_ number: DoubleBig, _ y: DoubleBig) -> Int {
    var xl = number //self
    var yl = y
    return Int(__gmpf_cmp(&xl.d, &yl.d))
}

func inBase(_ number: DoubleBig, _ base: Int) -> String {
    var ti = number.d
    var ex : Int = Int(mp_exp_t()) as Int // this is the deimal place
    let p = __gmpf_get_str(nil, &ex, CInt(base), 0, &ti)
    var s = String(cString: p!)
    if(ex < s.characters.count) {
        // add the decimal character to the floating point
        let si = s.index(s.startIndex, offsetBy: ex)
        s.insert(".", at: si)
    } else {
        // add padding 
        for _ in 0..<(ex - s.characters.count) {
            s.append("0")
        }
    }
    return s
}

public func string(_ number: DoubleBig) -> String {
    return inBase(number, 10)
}

/// Multiple-precision Integer
// Swift IntBig are, just like regular Int, by value-based, so no changing it once inited.
public struct IntBig {
    var i: mpz_t
    var inited: Bool

    public init() {
        i = mpz_t()
        __gmpz_init(&i)
        inited = true
    }
}

extension IntBig {
    
    public init(_ x: Int) {
        self.init()

        let y = CLong(x)
        if Int(y) == x {
            __gmpz_set_si(&i, y)
        } else {
            var negative = false
            var nx = x
            if x < 0 {
                nx = -x
                negative = true
            }
            
            __gmpz_import(&i, 1, 0, 8, 0, 0, &nx)
            if negative {
                __gmpz_neg(&i, &i)
            }
        }
        
    }

    public init(_ buffer: [UInt8]) {
        self.init(0)
        var b = buffer
        if buffer.count != 0 {
            __gmpz_import(&i, size_t(buffer.count), 1, 1, 1, 0, &b)
        }
    }
    
    public init(_ string: String) {
        self.init()
        __gmpz_set_str(&i,(string as NSString).utf8String, 10)
        
    }
}

func _Int_finalize(_ z: inout IntBig) {
    if z.inited {
        __gmpz_clear(&z.i)
    }
}

func clear(_ z: inout IntBig) {
    _Int_finalize(&z)
}

func sign(_ number: IntBig) -> Int {
    if number.i._mp_size < 0 {
        return -1
    } else {
        return Int(number.i._mp_size)
    }
}


// Int64
public func getInt64(_ number: IntBig) -> Int? {
    var oldIntBig = number
    
    if oldIntBig.inited == false { return nil }
    
    if __gmpz_fits_slong_p(&oldIntBig.i) != 0 {
        return Int(__gmpz_get_si(&oldIntBig.i))
    }
    // Undefined result if > 64 return nil
    if bitLen(oldIntBig) > 64 { return nil }
    
    var newInt64 = Int()
    __gmpz_export(&newInt64, nil, -1, 8, 0, 0, &oldIntBig.i)
    if sign(oldIntBig) < 0 {
        newInt64 = -newInt64
    }
    return newInt64
}


public func abs(_ x: IntBig) -> IntBig {
    var a = x
    var c = IntBig() //self
    __gmpz_abs(&c.i, &a.i)
    return c
}

public func neg(_ x: IntBig) -> IntBig {
    var a = x
    var c = IntBig() //self
    __gmpz_neg(&c.i, &a.i)
    return c
}

public func add(_ x: IntBig, _ y: IntBig) -> IntBig {
    var a = x
    var b = y
    var c = IntBig() //self
    __gmpz_add(&c.i, &a.i, &b.i)
    return c
}

public func sub(_ x: IntBig, _ y: IntBig) -> IntBig {
    var a = x
    var b = y
    var c = IntBig() //self
    __gmpz_sub(&c.i, &a.i, &b.i)
    return c
}

public func mul(_ x: IntBig, _ y: IntBig) -> IntBig {
    var a = x
    var b = y
    var c = IntBig() //self
    __gmpz_mul(&c.i, &a.i, &b.i)
    return c
}

func inBase(_ number: IntBig, _ base: Int) -> String {
    var ti = number.i
    let p = __gmpz_get_str(nil, CInt(base), &ti)
    let s = String(cString: p!)
    return s
}

public func string(_ number: IntBig) -> String {
    return inBase(number, 10)
}

// DivMod sets z to the quotient x div y and m to the modulus x mod y
// and returns the pair (z, m) for y != 0.
// If y == 0, a division-by-zero run-time panic occurs.
//
// DivMod implements Euclidean division and modulus (unlike Go):
//
//	q = x div y  such that
//	m = x - y*q  with 0 <= m < |q|
//
// (See Raymond T. Boute, ``The Euclidean definition of the functions
// div and mod''. ACM Transactions on Programming Languages and
// Systems (TOPLAS), 14(2):127-144, New York, NY, USA, 4/1992.
// ACM press.)
public func divMod(_ x: IntBig, _ y: IntBig, _ m: IntBig) -> (IntBig, IntBig) {
    var xl = x
    var yl = y
    var ml = m
    var zl = IntBig() //self
    
    switch sign(yl) {
    case 1:
        __gmpz_fdiv_qr(&zl.i, &ml.i, &xl.i, &yl.i)
    case -1:
        __gmpz_cdiv_qr(&zl.i, &ml.i, &xl.i, &yl.i)
    default:
        fatalError("Division by zero")
    }
    return (zl, ml)
}

// Cmp compares x and y and returns:
//
//   -1 if x <  y
//    0 if x == y
//   +1 if x >  y
public func cmp(_ number: IntBig, _ y: IntBig) -> Int {
    var xl = number //self
    var yl = y
    var r = Int(__gmpz_cmp(&xl.i, &yl.i))
    if r < 0 {
        r = -1
    } else if r > 0 {
        r = 1
    }
    return r
}

public func bytes(_ number: IntBig) -> [UInt8] {
    var num = number//self
    let size = 1 + ((bitLen(number) + 7) / 8)
    var b = [UInt8](repeating: UInt8(0), count: size)
    var n = size_t(b.count)
    __gmpz_export(&b, &n, 1, 1, 1, 0, &num.i)
    
    return Array(b[0..<n])
}

func bitLen(_ number: IntBig) -> Int {
    var num = number
    if sign(number) == 0 {
        return 0
    }
//    var c = self
    return Int(__gmpz_sizeinbase(&num.i, 2))
}
