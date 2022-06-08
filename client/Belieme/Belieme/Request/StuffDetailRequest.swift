//
//  StuffDetailRequest.swift
//  Belieme
//
//  Created by mac on 2022/06/04.
//

import Foundation

func addAmountOfStuff(name : String, amount: Int, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> Bool {
    let api : String = "stuffs/\(name)/items/"
    guard let jsonData = requestPost(api: api, method: "POST", param: ["amount": amount], exceptionHandler: exceptionHandler) else {
        return false
    }
    guard let data : Stuff = try? JSONDecoder().decode(Stuff.self, from: jsonData) else {
        return false
    }
    return data.name == name
}

func changeStuffInfo(existingName : String, name : String, emoji : String, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> Bool {
    let api : String = "stuffs/\(existingName)"
    guard requestPost(api: api, method: "PATCH", param: ["name" : name, "emoji" : emoji], exceptionHandler: exceptionHandler) != nil else {
        return false
    }
    return true
}

func getStuffDetail(name : String, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> [StuffDetail] {
    let stuffDetails : [StuffDetail] = []
    let api : String = "stuffs/\(name)/items/"
    guard let jsonData = requestGet(api: api, exceptionHandler: exceptionHandler) else {
        return stuffDetails
    }
    guard let datas : [StuffDetail] = try? JSONDecoder().decode([StuffDetail].self, from: jsonData) else {
        return stuffDetails
    }
    return datas
}

func findStuff(name : String, itemNum : Int, historyNum : Int, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> Bool {
    let api : String = "stuffs/\(name)/items/\(itemNum)/histories/\(historyNum)/found/"
    guard requestPost(api: api, method: "PATCH", param: [:], exceptionHandler: exceptionHandler) != nil else {
        return false
    }
    return true
}

func lostStuff(name: String, itemNum : Int, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> Bool {
    let api : String = "stuffs/\(name)/items/\(itemNum)/histories/lost/"
    guard requestPost(api: api, method: "PATCH", param: [:], exceptionHandler: exceptionHandler) != nil else {
        return false
    }
    return true
}

func createNewStuff(name : String, emoji : String, amount : Int, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> Bool {
    let api : String = "stuffs/"
    guard requestPost(api: api, method: "POST", param: ["name" : name, "emoji" : emoji, "amount" : amount],exceptionHandler: exceptionHandler) != nil else {
        return false
    }
    return true
}
