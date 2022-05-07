//
//  RequestFunction.swift
//  Belieme
//
//  Created by mac on 2022/04/15.
//

import UIKit

let baseUrl = "https://belieme.herokuapp.com/"

struct Response: Codable {
    let success: Bool
    let result: String
    let message: String
}

func requestGet(api: String) -> Data? {
    let newUrl = baseUrl + (api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? api)
    guard let url = URL(string: newUrl) else {
        print("Error: cannot create URL")
        return nil
    }

    var jsonData : Data? = nil
    var request = URLRequest(url: url)
    request.addValue("test token", forHTTPHeaderField: "user-token")
    request.httpMethod = "GET"
    
    let semaphore = DispatchSemaphore(value: 0)
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("Error: error calling GET")
            print(error!)
            semaphore.signal()
            return
        }
        guard let data = data else {
            print("Error: Did not receive data")
            semaphore.signal()
            return
        }
        guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
            print("Error: HTTP request failed")
            semaphore.signal()
            return
        }
        guard let stringData : String = String(data: data, encoding: .utf8) else {
            print("Error: data to string failed.")
            semaphore.signal()
            return
        }
        jsonData = stringData.data(using: .utf8)
        semaphore.signal()
    }.resume()
    semaphore.wait()
    return jsonData
}

func requestPost(api: String, method: String, param: [String: Any]) -> Data? {
    let newUrl = baseUrl + (api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? api)
    let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
    guard let url = URL(string: newUrl) else {
        print("Error: cannot create URL")
        return nil
    }
    
    var jsonData : Data? = nil
    var request = URLRequest(url: url)
    request.httpMethod = method
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("test token", forHTTPHeaderField: "user-token")
    request.httpBody = sendData
    let semaphore = DispatchSemaphore(value: 0)
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            print("Error: error calling GET")
            print(error!)
            semaphore.signal()
            return
        }
        guard let data = data else {
            print("Error: Did not receive data")
            semaphore.signal()
            return
        }
        guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
            print("error : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
            print("msg : ", (response as? HTTPURLResponse)?.description ?? "")
            semaphore.signal()
            return
        }
        guard let stringData : String = String(data: data, encoding: .utf8) else {
            print("Error: data to string failed.")
            semaphore.signal()
            return
        }
        jsonData = stringData.data(using: .utf8)
        semaphore.signal()
        
    }.resume()
    semaphore.wait()
    return jsonData
}
