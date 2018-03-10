//
//  Authenticate.swift
//  Parade
//
//  Created by Antoine Sauray on 10/03/2018.
//  Copyright © 2018 Parade Protection. All rights reserved.
//

import Foundation
import Alamofire

func authenticate(email: String, password: String, group: DispatchGroup) {
    Alamofire.request("https://authentication-dot-parade-194715.appspot.com/authenticate/caretaker").responseJSON { response in
        
        print("Request: \(String(describing: response.request))")   // original url request
        print("Response: \(String(describing: response.response))") // http url response
        print("Result: \(response.result)")                         // response serialization result
        
        if let json = response.result.value {
            print("JSON: \(json)") // serialized json response
        }
        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data: \(utf8Text)") // original server data as UTF8 string
        }
    }
}
