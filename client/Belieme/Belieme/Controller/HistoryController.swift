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
    
    func refreshAction() {
        guard let studentId = curUser.studentId else {
            return
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        historySections = (isAdmin)
            ? getAllHistoriesByAdmin(exceptionHandler: basicHttpExceptionHandler())
            : getAllHistoriesOfUser(id: studentId, exceptionHandler: basicHttpExceptionHandler())
        
        if(tokenExpired) {
            checkTokenExpiredAndSendAlert(viewController : self)
            return  
        }
        
        HistoryTable.reloadData()
    }
    
    @objc private func pullToRefresh(_ sender: Any) {
        refreshAction()
        HistoryTable.refreshControl?.endRefreshing()
    }
    
    func initView() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        HistoryTable.refreshControl = refresh
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshAction()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (historyNeedToUpdate) {
            historyNeedToUpdate = false
            refreshAction()
            initView()
        }
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
            historyNum: item.historyNum,
            exceptionHandler: basicHttpExceptionHandler()
        )
        
        if(tokenExpired) {
            checkTokenExpiredAndSendAlert(viewController : self)
            return
        }
        
        let alert = UIAlertController(
            title : (result) ? "반납처리 되었습니다." : "다시 시도해 주세요.",
            message: nil,
            preferredStyle : .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default) { UIAlertAction in
            if (result) {
                self.refreshAction()
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
            historyNum: item.historyNum,
            exceptionHandler: basicHttpExceptionHandler()
        )
        
        if(tokenExpired) {
            checkTokenExpiredAndSendAlert(viewController : self)
            return
        }
        
        let alert = UIAlertController(
            title : (result) ? "취소처리 되었습니다." : "다시 시도해 주세요.",
            message: nil,
            preferredStyle : .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default) { UIAlertAction in
            if (result) {
                self.refreshAction()
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
            historyNum: item.historyNum,
            exceptionHandler: basicHttpExceptionHandler()
        )
        
        if(tokenExpired) {
            checkTokenExpiredAndSendAlert(viewController : self)
            return
        }
        
        let alert = UIAlertController(
            title : (result) ? "승인처리 되었습니다." : "다시 시도해 주세요.",
            message: nil,
            preferredStyle : .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default) { UIAlertAction in
            if (result) {
                self.refreshAction()
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension HistoryController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if #available(iOS 15, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return 3
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        (view as! UITableViewHeaderFooterView).textLabel!.textColor = UIColor.systemGray5
        view.layer.addBorder([.top], color: UIColor.black, width: 1.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index: Int = section
        return historySections[index].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let index: Int = section
        let status = historySections[index].status
        let count = historySections[index].items.count
        let name = (status == .WAITING)
            ? "승인대기 (\(count))"
            : (status == .RENTING)
                ? "대여중 (\(count))"
                : "반납완료 (\(count))"
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
        if (!isAdmin) {
            return
        }
        let section: Int = indexPath.section
        let row: Int = indexPath.row
        historySections[section].items[row].isOpened = !(historySections[section].items[row].isOpened)
        tableView.reloadData()
        tableView.cellForRow(at: indexPath)?.setSelected(true, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCellId", for: indexPath) as! HistoryCell
        let section: Int = indexPath.section
        let row: Int = indexPath.row
        
        let target = historySections[section].items[row]
        cell.selectionStyle = .none
        cell.returnedButton.tag = row
        cell.rejectButton.tag = row
        cell.admitButton.tag = row
        cell.returnedButton.setTitle("반납완료", for: .normal)
        cell.rejectButton.setTitle("거절", for: .normal)
        cell.admitButton.setTitle("승인", for: .normal)
        
        if (section == 0) {
            cell.dateLabel.text = dateFormatter.string(from: target.requestTime)
        } else if (section == 1) {
            cell.dateLabel.text = dateFormatter.string(from: target.approveTime!)
        } else {
            cell.dateLabel.text = dateFormatter.string(from: target.returnedTime!)
        }
        
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
                cell.rejectButton.isHidden = false
                cell.admitButton.isHidden = false
                cell.returnedButton.isHidden = true
            } else if (section == 1) {
                cell.rejectButton.isHidden = true
                cell.admitButton.isHidden = true
                cell.returnedButton.isHidden = false
            }
        }
        cell.nameLabel.text = target.stuffName
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)

    
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
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
    
        }
        
    }
}

