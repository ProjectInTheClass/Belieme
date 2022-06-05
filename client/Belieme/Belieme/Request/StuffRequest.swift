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

func sendRentRequest(stuffName : String) -> Bool {
    let api : String = "histories/reserve/"
    guard requestPost(api: api, method: "POST", param: ["stuffName": stuffName]) != nil else {
        return false
    }
    return true
}
