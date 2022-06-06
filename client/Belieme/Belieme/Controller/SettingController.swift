//
//  SettingController.swift
//  Belieme
//
//  Created by yelin on 2022/04/15.
//

import Foundation
import UIKit

var changedFlag : Int = 0

class SettingController: UIViewController{
    
    @IBOutlet weak var AccountSetting: UIView!
    @IBOutlet weak var AppSetting: UIView!
    @IBOutlet weak var changeModeBtn: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func changeMode(_ sender: UIButton) {
        let str = getModeChageString()
        isAdmin = (!isAdmin)
        changedFlag = 2
        sender.setTitle(getModeChageString(), for: .normal)
        let startIndex = str.index(str.startIndex,offsetBy: 0)
        let endIndex = str.index(str.startIndex,offsetBy: 5)
        let title = String(str[startIndex ... endIndex])
        let alert = UIAlertController(
            title: title ,
            message: "모드가 변경되었습니다.",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        curUser.studentId = nil
        curUser.token = nil
        curUser.name = nil
        curUser.approvalTimeStamp = nil
        curUser.createTimeStamp = nil
        curUser.permission = nil
        UserDefaults.standard.removeObject(forKey: "user-token")
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        changeModeBtn.setTitle(getModeChageString(), for: .normal)
        AccountSetting.layer.cornerRadius = 10;
        AccountSetting.layer.borderColor = UIColor.systemBlue.cgColor;
        AccountSetting.layer.borderWidth = 1;
        
        AppSetting.layer.cornerRadius = 10;
        AppSetting.layer.borderColor = UIColor.systemBlue.cgColor;
        AppSetting.layer.borderWidth = 1;
        
        changeModeBtn.setTitle(getModeChageString(), for: .reserved)
     
        //backbutton 색상 변경
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func getModeChageString() -> String {
        if(isAdmin) {
            return "사용자 모드로 전환"
        } else {
            return "관리자 모드로 전환"
        }
    }
    
}
