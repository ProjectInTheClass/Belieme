//
//  LoginRequest.swift
//  Belieme
//
//  Created by mac on 2022/05/17.
//

import Foundation

func postAccessToken(accessToken : String, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> Bool {
    guard let jsonData = requestPost(api: "login/", method: "PATCH", param: ["apiToken": accessToken], exceptionHandler: exceptionHandler) else {
        return false
    }
    guard let data : CurrentUser = try? JSONDecoder().decode(CurrentUser.self, from: jsonData) else {
        return false
    }
    
    curUser.createTimeStamp = data.createTimeStamp
    curUser.approvalTimeStamp = data.approvalTimeStamp
    curUser.permission = data.permission
    curUser.studentId = data.studentId
    curUser.name = data.name
    curUser.token = data.token
    return true
}

func getUserInfo(exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> Bool {
    guard let jsonData = requestGet(api: "auth/", exceptionHandler: exceptionHandler) else {
        return false
    }
    guard let data : CurrentUser = try? JSONDecoder().decode(CurrentUser.self, from: jsonData) else {
        return false
    }
    curUser.createTimeStamp = data.createTimeStamp
    curUser.approvalTimeStamp = data.approvalTimeStamp
    curUser.permission = data.permission
    curUser.studentId = data.studentId
    curUser.name = data.name
    return true
}

func checkLogin(exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> Bool {
    guard let token = UserDefaults.standard.string(forKey: "user-token") else {
        return false
    }
    curUser.token = token
    return getUserInfo(exceptionHandler: exceptionHandler)
}
