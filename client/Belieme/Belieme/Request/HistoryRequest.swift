//
//  HistoryRequest.swift
//  Belieme
//
//  Created by mac on 2022/05/07.
//

import Foundation

private func getAllHistory(api : String, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> [HistorySection] {
    var historySections : [HistorySection] = [
        HistorySection(status: .WAITING, items: []),
        HistorySection(status: .RENTING, items: []),
        HistorySection(status: .RETURNED, items: [])
    ]
    guard let jsonData = requestGet(api: api, exceptionHandler : exceptionHandler) else {
        return historySections
    }
    guard let datas : [StuffInfo] = try? JSONDecoder().decode([StuffInfo].self, from: jsonData) else {
        return historySections
    }
    for data in datas {
        guard let status = getEnumStatusFromStringStatus(status: data.status) else {
            continue
        }
        guard let requestTime = getDateFromTimestamp(unixTime: data.reservedTimeStamp) else {
            continue
        }
        let approveTime = getDateFromTimestamp(unixTime: data.approveTimeStamp)
        let returnedTime = getDateFromTimestamp(unixTime: data.returnTimeStamp)
        let historyInfo : HistoryInfo = HistoryInfo(
            status: status,
            stuffName: data.item.stuffName,
            itemNum: data.item.num,
            historyNum: data.num,
            requestTime: requestTime,
            requester: data.requester?.name ?? "UNKNOWN",
            returnedTime: returnedTime,
            approveTime: approveTime
        )
        switch (status) {
        case .WAITING:
            historySections[0].items.append(historyInfo)
            break
        case .RENTING:
            historySections[1].items.append(historyInfo)
            break
        case .RETURNED:
            historySections[2].items.append(historyInfo)
        }
    }
    return historySections
}

func getAllHistoriesByAdmin(exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> [HistorySection] {
    return getAllHistory(api: "histories/", exceptionHandler: exceptionHandler)
}

func getAllHistoriesOfUser(id: String, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> [HistorySection] {
    return getAllHistory(api: "histories/?studentId=\(id)", exceptionHandler: exceptionHandler)
}

private func changeHistory(api : String, status : String, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> Bool {
    guard let jsonData = requestPost(api: api, method: "PATCH", param: [:], exceptionHandler: exceptionHandler) else {
        return false
    }
    guard let data : StuffInfo = try? JSONDecoder().decode(StuffInfo.self, from: jsonData) else {
        return false
    }
    return (data.status == status)
}

func changeRequestToRenting(stuffName: String, stuffNum: Int, historyNum: Int, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> Bool {
    let api = "stuffs/\(stuffName)/items/\(stuffNum)/histories/\(historyNum)/approve/"
    return changeHistory(api: api, status: "USING", exceptionHandler: exceptionHandler)
}

func changeRentingToReturn(stuffName: String, stuffNum: Int, historyNum: Int, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> Bool {
    let api = "stuffs/\(stuffName)/items/\(stuffNum)/histories/\(historyNum)/return/"
    return changeHistory(api: api, status: "RETURNED", exceptionHandler: exceptionHandler)
}

func changeRentingToCancel(stuffName: String, stuffNum: Int, historyNum: Int, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> Bool {
    let api = "stuffs/\(stuffName)/items/\(stuffNum)/histories/\(historyNum)/cancel/"
    return changeHistory(api: api, status: "EXPIRED", exceptionHandler: exceptionHandler)
}
