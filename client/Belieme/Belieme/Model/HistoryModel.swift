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

/*
 {
         "item" : {
             "stuffName" : "우산",
             "stuffEmoji" : "🌂",
             "num" : 1
         },
         "num" : 5,
         "requester" : {
             "studentId" : "2018008886",
             "name" : "이석환"
         },
         "approveManager" : {
             "studentId" : "2018008886",
             "name" : "이석환"
         },
         "returnManager" : null,
         "lostManager" : null,
         "cancelManager" : null,
       "reservedTimeStamp" : 1649862523,
       "approveTimeStamp" : 1649862735,
       "returnTimeStamp" : 0,
       "lostTimeStamp" : 0,
         "cancelTiemStamp": 0,
         "status" : "USING"
     },
 */

struct ItemInfo {
    let stuffName: String
    let stuffEmoji: String
    let num: Int
}

struct HistoryObject {
    let item: ItemInfo
    let requester: User
    
    let approveManager: User?
    let returnManager: User?
    let lostManager: User?
    let cancelManager: User?
    
    let reservedTime: Date
    let approvedTime: Date?
    let returnedTime: Date?
    let lostTime: Date?
    let cancelTime: Date?
    
    let status: String
}

/*
 기록 전부 불러오기 -> 어드민 || 일반
 */
func getAllHistories() -> [HistoryObject] {
    return []
}


/*
 특정 기록 상세 불러오기 -> 어드민
 */
//func getHistory(item: HistoryObject) -> HistoryObject {
//    return HistoryObject(item: <#T##ItemInfo#>, requester: <#T##User#>, approveManager: <#T##User?#>, returnManager: <#T##User?#>, lostManager: <#T##User?#>, cancelManager: <#T##User?#>, reservedTime: <#T##Date#>, approvedTime: <#T##Date?#>, returnedTime: <#T##Date?#>, lostTime: <#T##Date?#>, cancelTime: <#T##Date?#>, status: <#T##String#>)
//}

/*
 물건 반납 승인 -> 어드민
 */
func returnItem(item: HistoryObject) {
    
}

/*
 물건 예약 거절 -> 어드민
 */
func rejectReserve(item: HistoryObject) {
    
}


/*
 물건 예약 승인 -> 어드민
 */
func approveReserve(item: HistoryObject) {
    
}

/*
 물건 분실 -> 어드민
 */
func lostItem(item: HistoryObject) {
    
}
