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

class HistoryController: UIViewController {
    @IBOutlet weak var HistoryTable: UITableView!
    public var historySections: [HistorySection] = [
        HistorySection(
            status: .WAITING, items: []
        ),
        HistorySection(
            status: .RENTING, items: []
        ),
        HistorySection(
            status: .RETURNED, items: []
        )
    ]
    public let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        print("History view Did Load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let studentId = curUser.studentId else {
            // TODO : 로그인 되지 않았을 때.
            return
        }

        print(isAdmin)
        historySections = (isAdmin)
            ? getAllHistoriesByAdmin()
            : getAllHistoriesOfUser(id: studentId)
        HistoryTable.reloadData()
    }
    
    @IBAction func returnedButtonTouched(_ sender: UIButton) {
        let items = historySections[1].items
        if (items.count <= sender.tag) {
            return
        }
        let item = items[sender.tag]
        let result = changeRentingToReturn(
            stuffName: item.stuffName,
            stuffNum: item.itemNum,
            historyNum: item.historyNum
        )
        if (result) {
            viewWillAppear(false)
        }
    }
    
    @IBAction func cancelButtonTouched(_ sender: UIButton) {
        let items = historySections[0].items
        if (items.count <= sender.tag) {
            return
        }
        let item = items[sender.tag]
        let result = changeRentingToCancel(
            stuffName: item.stuffName,
            stuffNum: item.itemNum,
            historyNum: item.historyNum
        )
        if (result) {
            viewWillAppear(false)
        }
    }
    
    @IBAction func adminButtonTouched(_ sender: UIButton) {
        let items = historySections[0].items
        if (items.count <= sender.tag) {
            return
        }
        let item = items[sender.tag]
        let result = changeRequestToRenting(
            stuffName: item.stuffName,
            stuffNum: item.itemNum,
            historyNum: item.historyNum
        )
        if (result) {
            viewWillAppear(false)
        }
    }
}

extension HistoryController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return (isAdmin) ? 3 : 2
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        (view as! UITableViewHeaderFooterView).textLabel!.textColor = UIColor.systemGray5
        view.layer.addBorder([.top], color: UIColor.black, width: 1.0)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index: Int = (isAdmin) ? section : section + 1
        return historySections[index].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let index: Int = (isAdmin) ? section : section + 1
        let status = historySections[index].status
        let name = (status == .WAITING)
            ? "승인대기"
            : (status == .RENTING)
                ? "대여중"
                : "반납완료"
        return name
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section: Int = indexPath.section
        let row: Int = indexPath.row
        if (isAdmin) {
            let isOpened = historySections[section].items[row].isOpened
            if (isOpened) {
                if (section == 2) {
                    return 108
                }
                return 150.0
            }
        }
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section: Int = indexPath.section
        let row: Int = indexPath.row
        historySections[section].items[row].isOpened = !(historySections[section].items[row].isOpened)
        tableView.reloadData()
        tableView.cellForRow(at: indexPath)?.setSelected(true, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCellId", for: indexPath) as! HistoryCell
        let section: Int = (isAdmin) ? indexPath.section : indexPath.section + 1
        let row: Int = indexPath.row
        
        let target = historySections[section].items[row]
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
            cell.userName.text = target.requester
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
        cell.nameLabel.text = target.stuffName
        cell.dateLabel.text = dateFormatter.string(from: target.requestTime)
    
        return cell
    }
}

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame =  CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
                
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
    
        }
        
    }
    
}

