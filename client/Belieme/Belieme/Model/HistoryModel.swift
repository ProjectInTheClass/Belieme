//
//  HistoryModel.swift
//  Belieme
//
//  Created by mac on 2022/04/14.
//

import UIKit
import Foundation

enum Status {
    case RENTING, WAITING, RETURNED
}

struct HistoryInfo {
    let status: Status
    let stuffName: String
    let itemNum: Int
    let historyNum: Int
    let requestTime: Date
    let requester: String
    let returnedTime: Date?
    let approveTime: Date?
    var isOpened: Bool = false
}

struct HistorySection {
    let status: Status
    var items: [HistoryInfo]
}
