//
//  StuffsController.swift
//  Belieme
//
//  Created by mac on 2022/04/14.
//

import UIKit

class StuffCell : UITableViewCell {
    @IBOutlet weak var emoji: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var goDetailBtn: UIImageView!
    @IBOutlet weak var lentalBtn: UIButton!
    
    func setCellByUserMode(userMode mode: Bool) {
        if(mode == true) {
            self.goDetailBtn.isHidden = false
            self.lentalBtn.isHidden = true
        } else {
            self.goDetailBtn.isHidden = true
            self.lentalBtn.isHidden = false
        }
    }
}

// MARK: - Outlet vars, functions and member vars
class StuffTabController: UIViewController {
    @IBOutlet weak var stuffTableView: UITableView!
    @IBOutlet weak var stuffAddButton: UIButton!
    var stuffsData : [Stuff] = []
    
    func setButton(){
        stuffAddButton.layer.cornerRadius = stuffAddButton.layer.frame.size.width / 2
        stuffAddButton.clipsToBounds = true
        stuffAddButton.setTitle("+", for: .normal)
        
        //폰트크기가 커지지가 않음...
        stuffAddButton.titleLabel?.font = UIFont.systemFont(ofSize: 100)
        stuffAddButton.layer.shadowColor = UIColor.gray.cgColor
        stuffAddButton.layer.shadowOffset = CGSize.zero
        stuffAddButton.layer.shadowOpacity = 1.0
        stuffAddButton.layer.shadowRadius = 6
    }
    
    func touchOkButton(stuffName: String) -> Void {
        let result : Bool = sendRentRequest(stuffName: stuffName, exceptionHandler: basicHttpExceptionHandler())
        if(tokenExpired) {
            checkTokenExpiredAndSendAlert(viewController : self)
            return
        }
        
        let alert = UIAlertController(
            title : (result) ? "요청에 성공하였습니다." : "요청에 실패하였습니다.",
            message: nil,
            preferredStyle : .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default) { UIAlertAction in
            self.setButton()
            self.stuffsData = getAllStuff(exceptionHandler: basicHttpExceptionHandler())
            if(tokenExpired) {
                checkTokenExpiredAndSendAlert(viewController : self)
                return
            }
            historyNeedToUpdate = true
            self.reloadView()
            self.stuffAddButton.isHidden = !isAdmin
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func lentalBtnClicked(_ sender: UIButton) {
        let data = stuffsData[sender.tag]
        let alert = UIAlertController(
            title: "대여 요청 보내기",
            message: "요청을 한 후에 학생회실에서 관리자를 통해 대여 승인 받으실 수 있습니다.",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "보내기", style: .default) { UIAlertAction in
            self.touchOkButton(stuffName: data.name)
        }
        let cancel = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancel)
        
        // TODO completion에 reloard Data 넣기
        present(alert, animated: true, completion: nil)
    }
}


extension StuffTabController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stuffsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stuffCell", for: indexPath) as! StuffCell
        let stuff = stuffsData[indexPath.row]
        
        cell.setCellByUserMode(userMode: isAdmin)
        
        cell.emoji.text = stuff.emoji
        cell.name.text = stuff.name
        if (!isAdmin) {
            cell.lentalBtn.backgroundColor = (stuff.count == 0) ? .systemGray6 : UIColor(red: 89, green: 172, blue: 255, alpha: 0)
            cell.lentalBtn.layer.cornerRadius = 10
           // cell.lentalBtn.layer.borderWidth = 1
           // cell.lentalBtn.layer.borderColor = UIColor.black.cgColor
            if (stuff.count == 0) {
                cell.lentalBtn.isEnabled = false
            }
        }
        cell.lentalBtn.setTitle("\(stuff.count) / \(stuff.amount)", for: .normal)
        cell.lentalBtn.tag = indexPath.row
        cell.tag = indexPath.row
       
        cell.selectionStyle = .none
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StuffCell
        if(isAdmin == true) {
            let selectedStuff = stuffsData[cell.tag]
            
            let storyboard = UIStoryboard(name: "StuffDetail", bundle: nil)
            let targetViewController = storyboard.instantiateViewController(withIdentifier:"SB_StuffDetail") as! StuffDetailController
            targetViewController.paramName = selectedStuff.name
            targetViewController.paramImage = selectedStuff.emoji
            targetViewController.paramCount = selectedStuff.amount
            
            self.navigationController?.pushViewController(targetViewController, animated: true)
        }
    }
}

// MARK: - Override functions of UIViewController
extension StuffTabController {
    @objc private func pullToRefresh(_ sender: Any) {
        setButton()
        stuffsData = getAllStuff(exceptionHandler: basicHttpExceptionHandler())
        if(tokenExpired) {
            checkTokenExpiredAndSendAlert(viewController : self)
            return
        }
        
        reloadView()
        stuffAddButton.isHidden = !isAdmin
        stuffTableView.refreshControl?.endRefreshing()
    }
    
    func initView() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        stuffTableView.refreshControl = refresh
    }
    
    func reloadView() {
        stuffTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("BREAK1")
        //backbutton 색상변경
        self.navigationController?.navigationBar.tintColor = .black
        setButton()
        stuffAddButton.isHidden = !isAdmin
        

        reloadView()
        initView()
        self.navigationController?.navigationBar.topItem?.title = "물품목록"

//        print("BREAK2")
    }
    
    @IBAction func goToAdd(_ sender: UIButton) {
        guard let secPage = self.storyboard?.instantiateViewController(withIdentifier: "SB_StuffAdd") as? StuffAddController else {
            return
        }
        secPage.modalPresentationStyle = .fullScreen
        self.present(secPage, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (stuffNeedUpdate || addFlag || modifyFlag) {
            if (stuffNeedUpdate) {
                stuffNeedUpdate = false
            }
            if (addFlag) {
                addFlag = false
            }
            if (modifyFlag) {
                modifyFlag = false
            }
            setButton()
            stuffsData = getAllStuff(exceptionHandler: basicHttpExceptionHandler())
            if(tokenExpired) {
                checkTokenExpiredAndSendAlert(viewController : self)
                return
            }
            reloadView()
            stuffAddButton.isHidden = !isAdmin
            initView()
        }
    }
}
