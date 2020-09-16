//
//  HWDataProtocol.swift
//  DataProtocol
//
//  Created by hanwe lee on 2020/09/16.
//  Copyright © 2020 hanwe. All rights reserved.
//

import UIKit


protocol HWDataProtocol:Codable {
    func toJson() -> String
    static func fromJson<T:HWDataProtocol>(jsonData:Data?,object:T) -> T?
}

extension HWDataProtocol {
    func toJson() -> String {
        var jsonString:String = ""
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.outputFormatting = .sortedKeys
        let jsonData = try? encoder.encode(self)
        if jsonData != nil {
            jsonString = String(data: jsonData!, encoding: .utf8) ?? ""
        }
        return jsonString
    }
    
    static func fromJson<T:HWDataProtocol>(jsonData:Data?,object:T) -> T? {
        var returnValue:T? = nil
        let decoder = JSONDecoder()
        if let data = jsonData, let result = try? decoder.decode(T.self, from: data) {
            returnValue = result
        }
        return returnValue
    }
}
