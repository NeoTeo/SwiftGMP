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
        return IntBig()
    }
    
    public func newIntBig(x: Swift.Int) -> IntBig {
        var newInt = IntBig()
        return newInt.setInt64(x)
    }
}