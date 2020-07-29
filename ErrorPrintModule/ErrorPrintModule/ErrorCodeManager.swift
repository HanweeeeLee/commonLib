//
//  ErrorCodeManager.swift
//  ErrorPrintModule
//
//  Created by hanwe on 2020/07/29.
//  Copyright © 2020 hanwe. All rights reserved.
//

import UIKit

enum TestEnum:Int {
    case case1 = 0
    case case2
    case case3
}

struct MyError {
    var errorCode:TestEnum
    var errorMsgLocalizedKey:String
}

class ErrorCodeManager: NSObject {
    
    internal static func getErrorMessage(errorCode:TestEnum) -> String {
        var resultValue:String = ""
        let msg:String = getLocalizedKeyFromErrorCode(errorCode: errorCode).localized
        resultValue = "\(msg)" + "\n" + "[\(errorCode.rawValue)]"
        
        return resultValue
    }
    
    private static func getLocalizedKeyFromErrorCode(errorCode:TestEnum) -> String {
        var returnValue:String = ""
        switch errorCode {
        case .case1:
            returnValue = LocalizedMap.LOCAL_1
            break
        case .case2:
            returnValue = LocalizedMap.LOCAL_2
            break
        case .case3:
            returnValue = LocalizedMap.LOCAL_3
            break
        }
        return returnValue
    }
}

extension String {
    var localized: String {
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
