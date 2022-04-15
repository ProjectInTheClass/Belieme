//
//  UserModel.swift
//  Belieme
//
//  Created by mac on 2022/04/15.
//

import Foundation


struct User {
    let student_id: String
    let name: String
    let isAdmin: Bool // true, false
}

func login(id: String, password: String) {
    requestPost(url: "한양API", method: "POST", param: ["id": "user_id", "pw": "user_pw"], completionHandler: { (success, data) in
        // data 에서 어드민이면 어드민 전역변수 온~~
        print(data)
    })
}

func logout() {
    // logout 구현
}
