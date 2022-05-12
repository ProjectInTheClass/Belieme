//
//  StuffDetailController.swift
//  Belieme
//
//  Created by 이석환 on 2022/04/22.
//

import UIKit

class StuffDetailController: UIViewController {
    var stuff = Stuff(name:"", emoji: "", amount: 0, count: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didLoad\(stuff.name)AAAAA")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("WillAppear\(stuff.name)AAAAA")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("didAppear\(stuff.name)AAAAA")
    }
}
