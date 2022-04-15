//
//  HistoryController.swift
//  Belieme
//
//  Created by mac on 2022/04/14.
//


import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var detailButton: UIButton?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel!
}

class HistoryController: UIViewController {

    @IBOutlet weak var HistoryTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("History view Did Load")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        HistoryTable.reloadData()
        print("Histroy view will Appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("History view will Disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("History view Did Disappear")
    }
}

extension HistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCellId", for: indexPath) as! HistoryCell
        return cell
    }
}
