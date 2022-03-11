//
//  Ether.swift
//  EtherWei
//
//  Created by hanwe on 2022/03/11.
//

import Foundation
import BigInt

struct Ether: Equatable {
    
    // MARK: private property
    
    private var value: String
    
    // MARK: internal property
    
    var rawValue: String {
        return self.value
    }
    
    var isZero: Bool {
        return Ether.removeHeadZero(self.rawValue) == "0" ? true : false
    }
    
    // MARK: lifeCycle
    
    init(_ value: String) {
        self.value = Ether.removeHeadZero(value)
    }
    
    // MARK: private function
    
    fileprivate static func removeHeadZero(_ value: String) -> String {
        let copyWeiArray = Array(value)
        var result = value
        if value.contains(".") {
            return value
        }
        
        for item in copyWeiArray {
            if item == "0" {
                if result.count == 1 {
                    break
                } else {
                    result.removeFirst()
                    continue
                }
            } else {
                break
            }
        }
        
        return String(result)
    }
    
    fileprivate func removeHeadZero(_ wei: Wei) -> Wei {
        return Wei(Ether.removeHeadZero(wei.rawValue))
    }
    
    fileprivate func dropRemain() -> Ether {
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
    
    // MARK: internal function
    
    static func == (lhs: Ether, rhs: Ether) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    func toWei() -> Wei {
        if self.rawValue.contains(".") {
            let splited = self.rawValue.split(separator: ".")
            if splited.count == 1 {
                var copySelf = self.rawValue
                copySelf.removeLast()
                return Wei(copySelf + "000000000000000000")
            }
            var appended: String = ""
            var decimalArr = Array(splited[1])
            for _ in 0..<18 {
                if decimalArr.count == 0 {
                    appended += "0"
                } else {
                    appended += String(decimalArr.first!)
                    decimalArr.removeFirst()
                }
            }
            return Wei(removeHeadZero(Wei(splited[0] + appended)).rawValue)
        } else {
            return Wei(self.rawValue + "000000000000000000")
        }
    }
    
    func multiple(rate: String) -> Ether {
        let selfWei = self.toWei()
        guard let bigUIntSelf = BigUInt.init(selfWei.rawValue) else { return Ether.init("0") }
        let rate = Ether(rate)
        let waiRate = rate.toWei()
        guard let rate = BigUInt.init(waiRate.rawValue) else { return Ether.init("0") }
        let weiResultRaw = bigUIntSelf.multiplied(by: rate).description
        return Wei(weiResultRaw).toEther().dropRemain()
    }
    
    func toDigitBelow(_ to: UInt = 6) -> String {
        if self.rawValue.contains(".") {
            let splited = self.rawValue.split(separator: ".")
            if splited.count < 2 {
                return self.rawValue
            }
            let underArr = Array(splited[1])
            var returnValue: String = String(splited[0]) + "."
            
            for i in 0..<to {
                if underArr.count > i {
                    returnValue.append(underArr[Int(i)])
                } else {
                    break
                }
            }
            return returnValue
        } else {
            return self.rawValue
        }
    }
    
}

