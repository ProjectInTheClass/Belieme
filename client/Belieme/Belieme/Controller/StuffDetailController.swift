//
//  StuffDetailController.swift
//  Belieme
//
//  Created by 이석환 on 2022/04/22.
//

import UIKit

var modifyFlag : Bool = false

class StuffDetailController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var stuffArray: Array<StuffDetail> = []
    var paramCount: Int = 0
    var paramImage: String = ""
    var paramName: String = ""
    var addedCount : Int = 0
    var alreadylostNumArray : Array<Int> = []
    var newlostNumArray : Array<Int> = []
    var findNumArray : Array<Int> = []
    var itemNumHistoryNum : [Int:Int] = [:]
    
    //let data = stuffsData[this.tag]
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var stuffImage: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stuffName: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    func Init(){
        self.stuffArray = getStuffDetail(name: paramName, exceptionHandler: basicHttpExceptionHandler())
        if(tokenExpired) {
            checkTokenExpiredAndSendAlert(viewController : self)
            return
        }
        
        if (self.stuffArray.count > 0) {
            stuffName.text = stuffArray[0].stuffName
            stuffImage.text = stuffArray[0].stuffEmoji
        } else {
            stuffName.text = paramName
            stuffImage.text = paramImage
        }
        findNumArray = []
        newlostNumArray = []
        alreadylostNumArray = []
        itemNumHistoryNum = [:]
        self.stuffArray.forEach {
            if ($0.status == "INACTIVE") {
                alreadylostNumArray.append($0.num)
            }
            if let lastHistory = $0.lastHistory {
                itemNumHistoryNum[$0.num] = lastHistory.num
            }
        }
        tableView.reloadData()
    }
    
    func touchOkButton() -> Void {
        stuffImage.tintColor = UIColor.clear
        stuffName.tintColor = UIColor.clear
        
        var result : Bool = true
        let newlostNumSet : Set<Int> = Set(newlostNumArray)
        let alreadylostNumSet : Set<Int> = Set(alreadylostNumArray)
        let findNumSet : Set<Int> = Set(findNumArray)
        
        
        if (addedCount > 0) {
            result = addAmountOfStuff(name: paramName, amount: addedCount, exceptionHandler: basicHttpExceptionHandler())
            if(tokenExpired) {
                checkTokenExpiredAndSendAlert(viewController : self)
                return
            }
            
            if (!result) {
                for _ in 0..<addedCount {
                    stuffArray.removeLast()
                }
            }
            addedCount = 0
        }
        
        if (result && ((stuffImage.text! != paramImage) || (stuffName.text! != paramName))) {
            result = changeStuffInfo(existingName: paramName, name: stuffName.text!, emoji: stuffImage.text!, exceptionHandler: basicHttpExceptionHandler())
            if(tokenExpired) {
                checkTokenExpiredAndSendAlert(viewController : self)
                return
            }
            
            if (result) {
                paramName = stuffName.text!
                paramImage = stuffImage.text!
            }
        }
        
        if (result) {
            let realFindSet = findNumSet.intersection(alreadylostNumSet)
            for itemNum in realFindSet {
                guard let hisNum = itemNumHistoryNum[itemNum] else {
                    continue
                }
                result = findStuff(name: paramName, itemNum: itemNum, historyNum: hisNum, exceptionHandler: basicHttpExceptionHandler())
                if(tokenExpired) {
                    checkTokenExpiredAndSendAlert(viewController : self)
                    return
                }
                
                if (!result) {
                    break
                }
            }
        }
        
        if (result) {
            let realLostSet = newlostNumSet.subtracting(alreadylostNumSet)
            for itemNum in realLostSet {
                result = lostStuff(name: paramName, itemNum: itemNum, exceptionHandler: basicHttpExceptionHandler())
                if(tokenExpired) {
                    checkTokenExpiredAndSendAlert(viewController : self)
                    return
                }
                
                if (!result) {
                    break
                }
            }
        }
        
        self.Init()
        
        
        let alert = UIAlertController(
            title : (result) ? "요청에 성공하였습니다." : "요청에 실패하였습니다.",
            message: nil,
            preferredStyle : .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default) { UIAlertAction in
            modifyFlag = true
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        guard stuffImage.text != nil else {
            return
        }
        guard stuffName.text != nil else {
            return
        }
        if (!stuffImage.text!.isSingleEmoji) {
            self.showToast(message: "이모지를 등록해 주세요.", font: .systemFont(ofSize: 12.0))
            return
        }
        if (stuffName.text!.count <= 0 || stuffName.text!.count >= 10) {
            self.showToast(message: "물품명을 등록해 주세요.", font: .systemFont(ofSize: 12.0))
            return
        }
        
        let alert = UIAlertController(
            title: "변경 사항을 저장하시겠습니까?",
            message: nil,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { UIAlertAction in
            self.touchOkButton()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func stuffNameChanged(_ sender: UITextField) {
        tableView.reloadData()
    }
    
    func getNewStuffDetail() -> StuffDetail {
        return StuffDetail(stuffName: stuffName.text!, stuffEmoji: stuffImage.text!, num: stuffArray.count + 1, status: "USABLE", lastHistory: nil)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        addedCount += 1
        self.stuffArray.append(getNewStuffDetail())
        let indexPath = IndexPath(row: self.stuffArray.count - 1, section: 0)
        tableView.beginUpdates()
        self.tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
        tableView.endUpdates()
    }
    
    func deleteCell(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            stuffArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stuffArray.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        let name : String = "\(stuffName.text!)#\(stuffArray[indexPath.row].num)"
        cell.textLabel?.text = (stuffArray[indexPath.row].status == "INACTIVE") ? "\(name) (분실)" : name
        cell.contentView.backgroundColor = (stuffArray[indexPath.row].status == "INACTIVE") ? .systemPink : .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let itemNum : Int = self.stuffArray[indexPath.row].num
        if (stuffArray[indexPath.row].status == "USABLE") {
            let miss = UIContextualAction(style: .normal, title: "분실") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                self.stuffArray[indexPath.row].status = "INACTIVE"
                self.newlostNumArray.append(itemNum)
                if let findIndex = self.findNumArray.firstIndex(of: itemNum) {
                    self.findNumArray.remove(at: findIndex)
                }
                tableView.reloadData()
                success(true)
            }
            miss.backgroundColor = .systemPink
            return UISwipeActionsConfiguration(actions:[miss])
        }
        let find = UIContextualAction(style: .normal, title: "회수") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.stuffArray[indexPath.row].status = "USABLE"
            self.findNumArray.append(itemNum)
            if let lostIndex = self.newlostNumArray.firstIndex(of: itemNum) {
                self.newlostNumArray.remove(at: lostIndex)
            }
            tableView.reloadData()
            success(true)
        }
        find.backgroundColor = .systemTeal
        return UISwipeActionsConfiguration(actions:[find])
    }
    
    func addDoneButton() {
        stuffName.addDoneButtonOnKeyboard()
        stuffImage.addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        Init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButton()
        
        stuffImage.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
            return newLength <= 1
    }
}

extension UITextField{
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0,y: 0,width: UIScreen.main.bounds.width,height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.doneButtonAction))
        doneButton.tintColor = .systemBlue
        
        let items = [flexSpace, doneButton]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction(){
        self.resignFirstResponder()  //키보드 내려가게끔
    }
}
