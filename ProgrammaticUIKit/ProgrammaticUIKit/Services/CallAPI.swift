//
//  CallAPI.swift
//  ProgrammaticUIKit
//
//  Created by Sarwaan Ansari on 3/13/21.
//

import Foundation
class CallAPI: ObservableObject {
    
    func get<T: Codable>(url: String, Structure: T.Type, headers: [String:Any]? = nil, parameters: [String: Any]? = nil, completion: @escaping (Bool, String?, T?) -> Void) {
        
        guard var url = URLComponents(string: url) else {
            completion(false, "Could not parse URL.", nil)
            return
        }
        
        if let parameters = parameters {
            var queryItems: [URLQueryItem] = []
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: value as? String))
            }
            url.queryItems = queryItems
        }
        
        guard let fullURL = url.url else {
            completion(false, "Could not parse URL.", nil)
            return
        }
        
        
        var request = URLRequest(url:fullURL)
        
        request.httpMethod = "GET"
        
        if let headers = headers {
            for (header, value) in headers {
                request.setValue(value as? String, forHTTPHeaderField: header)
            }
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                completion(false, "Unknown error", nil)
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                completion(false, "statusCode should be 2xx, but is \(response.statusCode)", nil)
                return
            }
            
            //Make escaping clause by try? else
            let resData = try? JSONDecoder().decode(T.self, from: data)
            
            // print("res \(resData)")
            if response.statusCode == 200 {
                completion(true, nil, resData)
                return
            }
            
        }.resume()
        
        return
        
    }
    
    func post<T: Codable>(url: String, Structure: T.Type, headers: [String:Any]? = nil, parameters: [String: Any]? = nil, completion: @escaping (Bool, String?, T?) -> Void) {
        
        guard let url = URLComponents(string: url) else {
            completion(false, "Could not parse URL.", nil)
            return
        }
        
        guard let fullURL = url.url else {
            completion(false, "Could not parse URL.", nil)
            return
        }
        
        
        var request = URLRequest(url:fullURL)
        
        request.httpMethod = "POST"
        
        
        if let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        if let headers = headers {
            for (header, value) in headers {
                request.setValue(value as? String, forHTTPHeaderField: header)
            }
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                completion(false, "Unknown error", nil)
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                completion(false, "statusCode should be 2xx, but is \(response.statusCode)", nil)
                return
            }
            
            //Make escaping clause by try? else
            let resData = try? JSONDecoder().decode(T.self, from: data)
            
            // print("res \(resData)")
            if response.statusCode == 200 {
                completion(true, nil, resData)
                return
            }
            
        }.resume()
        
        return
        
    }
    
}
