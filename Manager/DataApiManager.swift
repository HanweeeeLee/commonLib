//
//  DataApiManager.swift
//  SeoulLost
//
//  Created by hanwe on 2020/06/07.
//  Copyright © 2020 hanwe. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class DataApiManager: NSObject {

    @discardableResult class func requestPOSTURL(_ strURL : String, params : Parameters = [:], headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) -> DataRequest{
        var httpHeaders:HTTPHeaders? = nil
        if headers != nil {
            httpHeaders = HTTPHeaders.init(headers!)
        }
        let dataRequest:DataRequest = AF.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: httpHeaders).validate().responseJSON { (responseObject) -> Void in
            
            switch responseObject.result {
            case .success(let value):
                //                print("value :\(value)")
                let resJson = JSON(value)
                success(resJson)
                break
            case .failure(let error):
                //                print("error :\(error)")
                let errorValue : Error = error
                failure(errorValue)
                break
            }
        }
        //        print("dataRequest.task :\(dataRequest.task)")
        return dataRequest
    }

    
    @discardableResult class func requestGETURL(_ strURL: String, headers : [String : String]?, success:@escaping(JSON)-> Void, failure:@escaping (Error) -> Void) -> DataRequest {
        var httpHeaders:HTTPHeaders? = nil
        if headers != nil {
            httpHeaders = HTTPHeaders.init(headers!)
        }
        let dataRequest:DataRequest = AF.request(strURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: httpHeaders).validate().responseJSON { (responseObject) -> Void in
            //print(responseObject)

            switch responseObject.result {
            case .success(let value):
                //                print("value :\(value)")
                let resJson = JSON(value)
                success(resJson)
                break
            case .failure(let error):
                //                print("error :\(error)")
                let errorValue : Error = error
                failure(errorValue)
                break
            }
        }

        return dataRequest
    }
}
