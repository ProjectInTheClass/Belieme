//
//  SMTP_SET.swift
//  Belieme
//
//  Created by yelin on 2022/05/30.
//

import Foundation
import SwiftSMTP


let smtp = SMTP(
    
    hostname: "smtp.gmail.com",     // SMTP server address
    email: "belieme.hyu@gmail.com",        // username to login
    password: "Belieme0hyu!"            // password to login
)

let mail_from = Mail.User(name: "Belieme", email: "belieme.hyu@gmail.com")
//let mail_to = Mail.User(name: "mail_to", email: "sky3nlq@gmail.com")

//let mail = Mail(
//    from: mail_from,
//    to: [mail_to],
//    subject: "Humans and robots living together in harmony and equality.",
//    text: "That was my ultimate wish."
//
//
//)



