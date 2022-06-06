//
//  SettingController.swift
//  Belieme
//
//  Created by yelin on 2022/04/15.
//

import Foundation
import UIKit

class SettingController: UIViewController{
    
    @IBOutlet weak var AccountSetting: UIView!
    @IBOutlet weak var AppSetting: UIView!
    @IBOutlet weak var changeModeBtn: UIButton!
   
    @IBAction func changeMode(_ sender: UIButton) {
        let str = getModeChageString()
        isAdmin = (!isAdmin)
        sender.setTitle(getModeChageString(), for: .reserved)
        
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    
        AccountSetting.layer.cornerRadius = 10;
        AccountSetting.layer.borderColor = UIColor.systemBlue.cgColor;
        AccountSetting.layer.borderWidth = 1;
        
        AppSetting.layer.cornerRadius = 10;
        AppSetting.layer.borderColor = UIColor.systemBlue.cgColor;
        AppSetting.layer.borderWidth = 1;
        
        changeModeBtn.setTitle(getModeChageString(), for: .reserved)
        
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func getModeChageString() -> String {
        if(isAdmin) {
            return "사용자 모드 전환"
        } else {
            return "관리자 모드 전환"
        }
    }
    
}
