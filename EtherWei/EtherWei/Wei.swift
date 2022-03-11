//
//  Wei.swift
//  EtherWei
//
//  Created by hanwe on 2022/03/11.
//

import Foundation
import BigInt

struct Wei: Equatable {
    
    // MARK: private property
    
    private var value: String
    
    // MARK: internal property
    
    var rawValue: String {
        return self.value
    }
    
    var isZero: Bool {
        if let test: Double = Double(self.rawValue) {
            return test == 0 ? true : false
        } else {
            return self.rawValue == "0" ? true : false
        }
    }
    
    // MARK: lifeCycle
    
    init(_ value: String) {
        self.value = value
    }
    
    // MARK: private function
    
    // MARK: internal function
    
    static func == (lhs: Wei, rhs: Wei) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    func toEther() -> Ether {
        var returnValue: String = ""
        var originValueArr = Array(self.rawValue)
        var decimal: String = ""
        for _ in 0..<18 {
            if originValueArr.count == 0 {
                decimal.insert("0", at: decimal.startIndex)
            } else {
                decimal.insert(originValueArr.last!, at: decimal.startIndex)
                originValueArr.removeLast()
            }
        }
        let integerArea = String(originValueArr) == "" ? "0" : String(originValueArr)
        returnValue = integerArea + "." + decimal
        while(true) {
            guard let lastValue = returnValue.last else { break }
            if lastValue == "." {
                returnValue.removeLast()
                break
            }
            if lastValue == "0" {
                returnValue.removeLast()
                continue
            } else {
                break
            }
        }
        return Ether.init(returnValue)
    }
    

}

