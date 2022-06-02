//
//  LoginRequest.swift
//  Belieme
//
//  Created by mac on 2022/05/17.
//

import Foundation

func postAccessToken(accessToken : String) -> Bool {
    guard let jsonData = requestPost(api: "login/", method: "PATCH", param: ["apiToken": accessToken]) else {
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