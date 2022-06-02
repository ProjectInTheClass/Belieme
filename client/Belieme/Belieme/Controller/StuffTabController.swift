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
    
    
    var stuffsData = [
        Stuff(name: "우산", emoji: "☂️", amount: 10, count: 2),
        Stuff(name: "축구공", emoji: "⚽️", amount: 3, count: 2),
        Stuff(name: "블루투스 스피커", emoji: "📻", amount: 2, count: 2)]
    
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
    
    @IBAction func lentalBtnClicked(_ sender: UIButton) {
        let data = stuffsData[sender.tag]
        let alert = UIAlertController(
            title: "대여 요청 보내기",
            message: "요청을 한 후에 학생회실에서 관리자를 통해 대여 승인 받으실 수 있습니다.",
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "보내기", style: .default) { UIAlertAction in
            print("ok alert is clicked : \(data.name)")
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setButton()
        reloadView()
        
        if (isAdmin == true){
            stuffAddButton.isHidden = false
        }
        else{
            stuffAddButton.isHidden = true
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


// MARK: - Function that
private extension StuffTabController {
    func reloadView() {
        // TODO 서버에서 불러오기
        stuffTableView.reloadData()
    }
}
