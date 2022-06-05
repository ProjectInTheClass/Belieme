//
//  SettingController.swift
//  Belieme
//
//  Created by yelin on 2022/04/15.
//

import Foundation
import UIKit

var changedFlag : Int = 3

class SettingController: UIViewController{
    
    @IBOutlet weak var AccountSetting: UIView!
    @IBOutlet weak var AppSetting: UIView!
    @IBOutlet weak var changeModeBtn: UIButton!
   
    @IBAction func changeMode(_ sender: UIButton) {
        isAdmin = (!isAdmin)
        changedFlag = 2
        sender.setTitle(getModeChageString(), for: .normal)
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
    }
    
    func getModeChageString() -> String {
        if(isAdmin) {
            return "사용자 모드 전환"
        } else {
            return "관리자 모드 전환"
        }
    }
    
}
