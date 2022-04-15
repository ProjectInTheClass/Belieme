//
//  HistoryController.swift
//  Belieme
//
//  Created by mac on 2022/04/14.
//


import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}

let item1 = HistoryObject(item: ItemInfo(stuffName: "aso", stuffEmoji: "asdasd", num: 1), requester: User(student_id: "123213", name: "sdddd"), approveManager: User(student_id: "123", name: "asdasd"), returnManager: nil, lostManager: nil, cancelManager: nil, reservedTime: Date(), approvedTime: nil, returnedTime: nil, lostTime: nil, cancelTime: nil, status: "good")

class HistoryController: UIViewController {

    @IBOutlet weak var HistoryTable: UITableView!
    public var historySections: [HistorySection] = [ HistorySection(name: "승인대기"), HistorySection(name: "대여중", items: [item1, item1]), HistorySection(name: "대여중", items: [item1]), HistorySection(name: "반납완료")]
    public let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HistoryTable.allowsSelection = isAdmin
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
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
    func numberOfSections(in tableView: UITableView) -> Int {
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 1.0
        }
        return (isAdmin == true) ? 3 : 2
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        (view as! UITableViewHeaderFooterView).textLabel!.textColor = UIColor.systemGray5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index: Int = (isAdmin == true) ? section : section + 1
        return historySections[index].items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let index: Int = (isAdmin == true) ? section : section + 1
        return historySections[index].name
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (tableView.cellForRow(at: indexPath)!.isSelected) {
            tableView.cellForRow(at: indexPath)!.setSelected(false, animated: false)
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableView.cellForRow(at: indexPath)!.isSelected)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCellId", for: indexPath) as! HistoryCell
        let section: Int = (isAdmin == true) ? indexPath.section : indexPath.section + 1
        let row: Int = indexPath.row
        
        let target = historySections[section].items![row]
        cell.nameLabel.text = target.item.stuffName
        cell.dateLabel.text = dateFormatter.string(from: target.reservedTime)
    
        return cell
    }
}
