import Foundation

func getAllStuff() -> [Stuff] {
    let api : String = "stuffs/"
    guard let jsonData = requestGet(api: api) else {
        return []
    }
    guard let datas : [Stuff] = try? JSONDecoder().decode([Stuff].self, from: jsonData) else {
        return []
    }
    return datas
}

func createNewStuff(name : String, emoji : String, amount : Int) -> [Stuff] {
    let api : String = "stuffs/"
    guard let jsonData = requestPost(api: api, method: "POST", param: ["name": name, "emoji" : emoji, "amount" : amount]) else {
        return []
    }
    guard let datas : [Stuff] = try? JSONDecoder().decode([Stuff].self, from: jsonData) else {
        return []
    }
    return datas
}

func sendRentRequest(stuffName : String) -> Bool {
    let api : String = "histories/reserve/"
    guard requestPost(api: api, method: "POST", param: ["stuffName": stuffName]) != nil else {
        return false
    }
    return true
}
