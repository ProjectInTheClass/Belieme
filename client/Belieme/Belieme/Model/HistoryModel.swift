//
//  HistoryModel.swift
//  Belieme
//
//  Created by mac on 2022/04/14.
//

import Foundation

let RENTING: Int = 0
let RETURNED: Int = 1
let WAITING: Int = 2

let IsAdmin = true

struct HistoryItem {
    let id: Int
    let name: String
    var returned: Bool
    let startDate: Date
    var finishDate: Date?
//    let byWho: User
}

struct HistoryMenu: Identifiable {
    var id : Int
    var name: String
    var subItems: [HistoryItem] = []
}

func getHistoryItem() -> [HistoryMenu] {
    // Server로 현재 나의 물품 내역 요청 , admin일경우와 admin이 아닐경우가 다르다~
    return []
}

func returnItem(item: HistoryItem) {
    // 제곧내 admin만 호출
}

func acceptRent(item: HistoryItem) {
    // 제곧내 admin만 호출
}

func cancelRent(item: HistoryItem) {
    // 제곧내 admmin만 호출
}
