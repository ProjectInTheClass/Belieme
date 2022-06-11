//
//  ViewController.swift
//  Belieme
//
//  Created by mac on 2022/04/14.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 0
//        print("BREAK3")
        if (checkLogin(exceptionHandler: logingHttpExceptionHandler())) {
            stuffNeedUpdate = true
            historyNeedToUpdate = true
            isAdmin = UserDefaults.standard.bool(forKey: "login-to-admin-mode")
      
            let stuffController = self.viewControllers?[0] as? StuffTabController
            stuffController?.stuffsData = getAllStuff(exceptionHandler: basicHttpExceptionHandler())
            stuffController?.reloadView()
            stuffController?.initView()
            if(tokenExpired) {
                checkTokenExpiredAndSendAlert(viewController : self)
                return
            }
            
            isAdmin = UserDefaults.standard.bool(forKey: "login-to-admin-mode")
            return
        }
        performSegue(withIdentifier: "SG_LoginTab", sender: nil)
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        let targetViewController = storyboard.instantiateViewController(withIdentifier:"SB_LoginTab")
//        targetViewController.modalPresentationStyle = .fullScreen
//        viewController.present(targetViewController, animated : false)
    }
    
    @IBAction func backToMain(_ sender: UIStoryboardSegue) {
        self.selectedIndex = 0
    }
}

extension UnicodeScalar {
    var isEmoji: Bool {
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
             0x1F300...0x1F5FF, // Misc Symbols and Pictographs
             0x1F680...0x1F6FF, // Transport and Map
             0x1F1E6...0x1F1FF, // Regional country flags
             0x2600...0x26FF, // Misc symbols
             0x2700...0x27BF, // Dingbats
             0xE0020...0xE007F, // Tags
             0xFE00...0xFE0F, // Variation Selectors
             0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
             0x1F018...0x1F270, // Various asian characters
             0x238C...0x2454, // Misc items
             0x20D0...0x20FF: // Combining Diacritical Marks for Symbols
            return true

        default: return false
        }
    }

    var isZeroWidthJoiner: Bool {
        return value == 8205
    }
}

extension String {
    var isSingleEmoji: Bool {
        return count == 1 && containsEmoji
    }

    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    var isValidEmail: Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension UIViewController {
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: 100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
