//
//  SwiftGMP.swift
//  SwiftGMP
//
//  Created by Teo on 21/05/15.
//  Copyright (c) 2015 Teo. All rights reserved.
//

import Foundation
import GMP

/// Multiple-precision Integer
public struct IntBig {
    var i: mpz_t
    var inited: Bool

    public init() {
        i = mpz_t()
        __gmpz_init(&i)
        inited = true
    }
    
    public init(x: Int) {
        self.init()
        setInt64(x)
    }
}

extension IntBig {

    func _Int_finalize(inout z: IntBig) {
        if z.inited {
            __gmpz_clear(&z.i)
        }
    }

    // Done by the struct init
//    func doInit(inout z: IntBig) {
//
//        if z.inited { return }
//        z.inited = true
//        __gmpz_init(&z.i)
//    }
    
    func clear(inout z: IntBig) {
        _Int_finalize(&z)
    }
    
    func sign() -> Int {
        if self.i._mp_size < 0 {
            return -1
        } else {
            return Int(self.i._mp_size)
        }
    }

    mutating func setInt64(x: Swift.Int) -> IntBig {
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
        return self
    }
    
//    public func newIntBig(x: Swift.Int) -> IntBig {
//        var newInt = IntBig()
//        return newInt.setInt64(x)
//    }

    
    public func abs(x: IntBig) -> IntBig {
        var a = x
        var c = self
        __gmpz_abs(&c.i, &a.i)
        return c
    }
    
    public func neg(x: IntBig) -> IntBig {
        var a = x
        var c = self
        __gmpz_neg(&c.i, &a.i)
        return c
    }

    public func add(x: IntBig, y: IntBig) -> IntBig {
        var a = x
        var b = y
        var c = self
        __gmpz_add(&c.i, &a.i, &b.i)
        return c
    }
    
    public func sub(x: IntBig, y: IntBig) -> IntBig {
        var a = x
        var b = y
        var c = self
        __gmpz_sub(&c.i, &a.i, &b.i)
        return c
    }
    
    public func mul(x: IntBig, y: IntBig) -> IntBig {
        var a = x
        var b = y
        var c = self
        __gmpz_mul(&c.i, &a.i, &b.i)
        return c
    }
    
    func inBase(base: Int) -> String {
        var ti = i
        let p = __gmpz_get_str(nil, CInt(base), &ti)
        let s = String.fromCString(p)
        return s!
    }
    
    public func string() -> String {
        return inBase(10)
    }
    
    // setBytes interprets buf as the bytes of a big-endian unsigned integer,
    // sets c to that value and returns it.
    public func setBytes(buf: [uint8]) -> IntBig {
        var c = self
        var b = buf
        if buf.count == 0 {
            c.setInt64(0)
        } else {
            __gmpz_import(&c.i, size_t(buf.count), 1, 1, 1, 0, &b)
        }
        return c
    }
    
    // cmp
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
    public func divMod(x: IntBig, y: IntBig, m: IntBig) -> (IntBig, IntBig) {
        var xl = x
        var yl = y
        var ml = m
        var zl = self
        
        switch yl.sign() {
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
    public func cmp(y: IntBig) -> Int {
        var xl = self
        var yl = y
        var r = Int(__gmpz_cmp(&xl.i, &yl.i))
        if r < 0 {
            r = -1
        } else if r > 0 {
            r = 1
        }
        return r
    }
    
    public func bytes() -> [uint8] {
        var c = self
        let size = 1 + ((bitLen() + 7) / 8)
        var b = [uint8](count: size, repeatedValue: uint8(0))
        var n = size_t(count(b))
        __gmpz_export(&b, &n, 1, 1, 1, 0, &c.i)
        
        return Array(b[0..<n])
    }

    func bitLen() -> Int {
        if self.sign() == 0 {
            return 0
        }
        var c = self
        return Int(__gmpz_sizeinbase(&c.i, 2))
    }
}