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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    
        AccountSetting.layer.cornerRadius = 10;
        AccountSetting.layer.borderColor = UIColor.systemBlue.cgColor;
        AccountSetting.layer.borderWidth = 1;
        
        AppSetting.layer.cornerRadius = 10;
        AppSetting.layer.borderColor = UIColor.systemBlue.cgColor;
        AppSetting.layer.borderWidth = 1;
    }
    
}
