//
//  StuffsController.swift
//  Belieme
//
//  Created by mac on 2022/04/14.
//

import UIKit

class StuffsController: UIViewController {
    var stuffsData = [
        Stuff(name: "우산", emoji: "☂️", amount: 10, count: 2),
        Stuff(name: "축구공", emoji: "⚽️", amount: 3, count: 2),
        Stuff(name: "블루투스 스피커", emoji: "📻", amount: 2, count: 2)]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return stuffsData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return stuffsData.index(indexPath)
//    }
}
