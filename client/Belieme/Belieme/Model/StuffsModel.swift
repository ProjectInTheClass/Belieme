//
//  StuffsModel.swift
//  Belieme
//
//  Created by mac on 2022/04/14.
//

import Foundation

struct Stuff {
    let name : String
    let emoji : String
    let amount : Int
    let count : Int
}

var stuffsData = [
    Stuff(name: "우산", emoji: "☂️", amount: 10, count: 2),
    Stuff(name: "축구공", emoji: "⚽️", amount: 3, count: 2),
    Stuff(name: "블루투스 스피커", emoji: "📻", amount: 2, count: 2)]
