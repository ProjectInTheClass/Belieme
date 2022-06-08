import Foundation

func getAllStuff(exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> [Stuff] {
    let api : String = "stuffs/"
    guard let jsonData = requestGet(api: api, exceptionHandler: exceptionHandler) else {
        return []
    }
    guard let datas : [Stuff] = try? JSONDecoder().decode([Stuff].self, from: jsonData) else {
        return []
    }
    return datas
}

func sendRentRequest(stuffName : String, exceptionHandler : @escaping (_ : URLResponse?) -> Bool) -> Bool {
    let api : String = "histories/reserve/"
    guard requestPost(api: api, method: "POST", param: ["stuffName": stuffName], exceptionHandler: exceptionHandler) != nil else {
        return false
    }
    return true
}
