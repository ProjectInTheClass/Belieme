//
//  UserModel.swift
//  Belieme
//
//  Created by mac on 2022/04/15.
//

import Foundation


struct User : Codable {
    let studentId: String
    let name: String
}

struct CurrentUser : Codable {
    var studentId: String?
    var name : String?
    var token : String?
    var createTimeStamp : Int?
    var approvalTimeStamp : Int?
    var permission : String?
}

var isAdmin: Bool = false
var curUser : CurrentUser = CurrentUser(studentId: nil, name: nil, token: nil, createTimeStamp: nil, approvalTimeStamp: nil, permission: nil)
