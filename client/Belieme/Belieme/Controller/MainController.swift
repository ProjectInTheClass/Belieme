//
//  ViewController.swift
//  Belieme
//
//  Created by mac on 2022/04/14.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (checkLogin()) {
            return
        }
        performSegue(withIdentifier: "SG_LoginTab", sender: nil)
    }
}
