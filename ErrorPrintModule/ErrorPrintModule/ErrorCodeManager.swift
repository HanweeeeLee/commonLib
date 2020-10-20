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

class ErrorCodeManager: NSObject {
    
    internal static func getErrMsg(errMsg:String,errorCode:Int?) -> String {
        var resultValue:String = ""
        resultValue = "\(errMsg)"
        if errorCode != nil {
            resultValue = resultValue + "\n[\(errorCode!)]"
        }
        return resultValue
    }
    
    internal static func getErrMsg(err:Error?,errorCode:Int?) -> String {
        var resultValue:String = ""
        var msg:String = ""
        if err != nil {
            msg = err!.localizedDescription
        }
        else {
            msg = "Error"//이렇게?
        }
        resultValue = "\(msg)"
        if errorCode != nil {
            resultValue = resultValue + "\n[\(errorCode!)]"
        }
        return resultValue
    }
    
    internal static func getErrMsg(errCode:TestEnum,error:Error? = nil) -> String {
        var resultValue:String = ""
        let msg:String = getLocalizedKeyFromErrorCode(errorCode: errCode).localized
        resultValue = "\(msg)" + "\n" + "[\(errCode.rawValue)]"
        if error != nil {
            resultValue = resultValue + "\n\(error!.localizedDescription)"
        }
        
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
