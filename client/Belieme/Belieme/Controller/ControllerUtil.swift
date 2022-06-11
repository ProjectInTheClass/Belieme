//
//  ControllerUtil.swift
//  Belieme
//
//  Created by 이석환 on 2022/06/08.
//

import Foundation
import UIKit

func checkTokenExpiredAndSendAlert(viewController : UIViewController) {
    let alert = UIAlertController(
        title : "토큰이 만료되었습니다. 다시 로그인 해주세요.",
        message: nil,
        preferredStyle : .alert
    )
    let okAction = UIAlertAction(title: "확인", style: .default) { UIAlertAction in
        curUser.studentId = nil
        curUser.token = nil
        curUser.name = nil
        curUser.approvalTimeStamp = nil
        curUser.createTimeStamp = nil
        curUser.permission = nil
        
        UserDefaults.standard.removeObject(forKey: "user-token")
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let targetViewController = storyboard.instantiateViewController(withIdentifier:"SB_LoginTab")
        targetViewController.modalPresentationStyle = .fullScreen
//        viewController.present(targetViewController, animated : false)
        viewController.navigationController?.pushViewController(targetViewController, animated: false)
        tokenExpired = false
        return
    }
    alert.addAction(okAction)
    viewController.present(alert, animated: true, completion: nil)
}
