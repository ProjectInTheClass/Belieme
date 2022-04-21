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
    @IBOutlet weak var whosRequestLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var returnedButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var admitButton: UIButton!
}

let item1 = HistoryObject(item: ItemInfo(stuffName: "aso", stuffEmoji: "asdasd", num: 1), requester: User(student_id: "123213", name: "sdddd"), approveManager: User(student_id: "123", name: "asdasd"), returnManager: nil, lostManager: nil, cancelManager: nil, reservedTime: Date(), approvedTime: nil, returnedTime: nil, lostTime: nil, cancelTime: nil, status: "good", isOpened: false)

class HistoryController: UIViewController {

    @IBOutlet weak var HistoryTable: UITableView!
    public var historySections: [HistorySection] = [ HistorySection(name: "승인대기", items: [item1, item1]), HistorySection(name: "대여중", items: [item1, item1]), HistorySection(name: "반납완료", items: [item1])]
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
    
    @IBAction func returnedButtonTouched(_ sender: UIButton) {
        // 반납 처리
        print("return \(sender.tag)")
        HistoryTable.reloadData()
    }
    
    @IBAction func rejectButtonTouched(_ sender: UIButton) {
        print("reject \(sender.tag)")
        HistoryTable.reloadData()
    }
    
    @IBAction func adminButtonTouched(_ sender: UIButton) {
        print("admit \(sender.tag)")
        HistoryTable.reloadData()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section: Int = indexPath.section
        let row: Int = indexPath.row
        let isOpened = historySections[section].items![row].isOpened
        if (isOpened) {
            if (section == 2) {
                return 108
            }
            return 150.0
        }
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section: Int = indexPath.section
        let row: Int = indexPath.row
        historySections[section].items![row].isOpened = !(historySections[section].items![row].isOpened)
        tableView.reloadData()
        tableView.cellForRow(at: indexPath)!.setSelected(true, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Load Table data.")
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCellId", for: indexPath) as! HistoryCell
        let section: Int = (isAdmin == true) ? indexPath.section : indexPath.section + 1
        let row: Int = indexPath.row
        
        let target = historySections[section].items![row]
        cell.selectionStyle = .none
        cell.returnedButton.tag = row
        cell.rejectButton.tag = row
        cell.admitButton.tag = row
        if (!target.isOpened) {
            cell.whosRequestLabel.isHidden = true
            cell.userName.isHidden = true
            cell.rejectButton.isHidden = true
            cell.admitButton.isHidden = true
            cell.returnedButton.isHidden = true
        } else {
            cell.whosRequestLabel.isHidden = false
            cell.userName.isHidden = false
            cell.whosRequestLabel.text = "대여자"
            cell.userName.text = target.requester.name
            if (section == 0) {
                cell.whosRequestLabel.text = "요청자"
                cell.admitButton.titleLabel!.text = "승인"
                cell.rejectButton.titleLabel!.text = "거절"
                cell.rejectButton.isHidden = false
                cell.admitButton.isHidden = false
                cell.returnedButton.isHidden = true
            } else if (section == 1) {
                cell.returnedButton.titleLabel!.text = "반납완료"
                cell.rejectButton.isHidden = true
                cell.admitButton.isHidden = true
                cell.returnedButton.isHidden = false
            }
        }
        cell.nameLabel.text = target.item.stuffName
        cell.dateLabel.text = dateFormatter.string(from: target.reservedTime)
    
        return cell
    }
}
