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
        let result : Bool = sendRentRequest(stuffName: stuffName)
        let alert = UIAlertController(
            title : (result) ? "요청에 성공하였습니다." : "요청에 실패하였습니다.",
            message: nil,
            preferredStyle : .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default)
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

// MARK: - Implemnts Deligate of TableView
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
        cell.lentalBtn.setTitle("\(stuff.count)/\(stuff.amount)", for: .normal)
        cell.lentalBtn.tag = indexPath.row
        cell.tag = indexPath.row
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StuffCell
        if(isAdmin == true) {
            performSegue(withIdentifier: "SG_StuffTabToStuffDetail", sender: cell)
        }
    }
}

// MARK: - Override functions of UIViewController
extension StuffTabController {
    @objc private func pullToRefresh(_ sender: Any) {
        setButton()
        stuffsData = getAllStuff()
        reloadView()
        stuffAddButton.isHidden = !isAdmin
        stuffTableView.refreshControl?.endRefreshing()
    }
    
    func initView() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        stuffTableView.refreshControl = refresh
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard curUser.studentId != nil else {
            return
        }
        setButton()
        stuffsData = getAllStuff()
        reloadView()
        stuffAddButton.isHidden = !isAdmin
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (changedFlag > 0) {
            changedFlag -= 1
            setButton()
            stuffsData = getAllStuff()
            reloadView()
            stuffAddButton.isHidden = !isAdmin
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let targetViewController = segue.destination as? StuffDetailController,
            let stuffCell = sender as? StuffCell
        else { return }
        
        let selectedStuff = stuffsData[stuffCell.tag]
        targetViewController.paramName = selectedStuff.name
        targetViewController.paramImage = selectedStuff.emoji
        targetViewController.paramCount = selectedStuff.amount
    }
}

private extension StuffTabController {
    func reloadView() {
        stuffTableView.reloadData()
    }
}
