//
//  StuffDetailModel.swift
//  Belieme
//
//  Created by mac on 2022/06/04.
//

import Foundation

struct StuffHistory : Codable {
    let num : Int
    let status: String
    let reservedTimeStamp: Int?
    let requester: User?
    let approveTimeStamp: Int?
    let approveManager: User?
    let lostTimeStamp: Int?
    let lostManager: User?
    let returnTimeStamp: Int?
    let returnManager: User?
    let cancelTimeStamp: Int?
    let cancelManager: User?
}

struct StuffDetail : Codable {
    let stuffName : String
    let stuffEmoji : String
    let num : Int
    var status : String
    let lastHistory : StuffHistory?
}
