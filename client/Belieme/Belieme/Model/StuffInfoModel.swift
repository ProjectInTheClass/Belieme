//
//  Stuff.swift
//  Belieme
//
//  Created by mac on 2022/05/07.
//

import Foundation

struct StuffInfo : Codable {
    let item: StuffDetail
    let num: Int
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



func getEnumStatusFromStringStatus(status: String) -> Status? {
    switch (status) {
    case "USING":
        return .RENTING
    case "REQUESTED":
        return .WAITING
    case "RETURNED":
        return .RETURNED
    default:
        return nil
    }
}

