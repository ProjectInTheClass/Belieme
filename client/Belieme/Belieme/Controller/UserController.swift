//
//  UserController.swift
//  Belieme
//
//  Created by mac on 2022/05/14.
//

import UIKit
import WebKit

enum LoginState {
case before, tried, success
}

class UserController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet var infoButtons: [UIButton]!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var pwField: UITextField!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loginNoticeLabel: UILabel!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var agreeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleContent: UITextView!
    @IBOutlet weak var detailContent: UITextView!
    @IBOutlet weak var disagreeButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var agreeLoginButton: UIButton!
    
    var loginState : LoginState = .before
    var indexOfOneAndOnlySelectedBtn: Int?
    var check = 0
    
    private let LOGIN_URL = URL(string: "http://api.hanyang.ac.kr/oauth/authorize?client_id=a4b1abe746f384c3d43fa82a17f222&redirect_uri=https://api.hanyang.ac.kr/&response_type=token&scope=10")
    private let FAIL_URL = "https://api.hanyang.ac.kr/oauth/login"
    private let ERROR_URL = "https://portal.hanyang.ac.kr/sso/openPage.do"
    private let FIRST_URL = "https://api.hanyang.ac.kr/oauth/offer"
    
    private let DEV_API_TOKEN = "c305ee87-a4c7-4b5a-8d71-7e23b6064613"
    private let DEV_ID = "__DEV__ID"
    private let DEV_PW = "__DEV__PW"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.style = .large
        indicator.color = .systemBlue
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.isHidden = true
        togleAgree(flag: true)
        loginButton.setTitle("LOGIN", for: .normal)
        addDoneButton()
        navigationController?.isNavigationBarHidden = true
        loadWebPage(LOGIN_URL)
    }

    private func togleAgree(flag : Bool) {
        agreeImage.isHidden = flag
        titleLabel.isHidden = flag
        titleContent.isHidden = flag
        detailContent.isHidden = flag
        disagreeButton.isHidden = flag
        agreeButton.isHidden = flag
        agreeLoginButton.isHidden = flag
        
        loginImage.isHidden = !flag
        idField.isHidden = !flag
        pwField.isHidden = !flag
        loginButton.isHidden = !flag
        loginNoticeLabel.isHidden = !flag
    }

    private func loadWebPage(_ url: URL?) {
        guard let url = url else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func presentLoginFailAlert() {
        let alert = UIAlertController(title: "로그인 실패", message: "다시 시도해 주십시오.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { _ in
            self.loginState = .before
            self.idField.text = ""
            self.pwField.text = ""
            self.loadWebPage(self.LOGIN_URL)
        }))
        present(alert, animated: true)
    }
    
    func addDoneButton() {
        idField.addDoneButtonOnKeyboard()
        pwField.addDoneButtonOnKeyboard()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
    
    @IBAction func touchAgreeOrDisagreeButton(_ sender: UIButton) {
        if indexOfOneAndOnlySelectedBtn != nil{
            if !sender.isSelected {
                for unselectIndex in infoButtons.indices {
                    infoButtons[unselectIndex].isSelected = false
                }
                sender.isSelected = true
                indexOfOneAndOnlySelectedBtn = infoButtons.firstIndex(of: sender)
                check = sender.tag
            } else {
                sender.isSelected = false
                indexOfOneAndOnlySelectedBtn = nil
                check = 0
            }
            
        } else {
            sender.isSelected = true
            indexOfOneAndOnlySelectedBtn = infoButtons.firstIndex(of: sender)
            check = sender.tag
        }
    }
    
    @IBAction func touchAgreeLoginButton(_ sender: UIButton) {
        guard let index = indexOfOneAndOnlySelectedBtn  else {
            return
        }
        let isChecked : Bool = (index == 0)
        let loginQuery = "$('input:checkbox[name=chkItem]').prop('checked', \(isChecked));\n$('#btnAgree').click();"
        webView.evaluateJavaScript(loginQuery)
    }
    
    @IBAction func touchLoginButton(_ sender: UIButton) {
        guard let id = idField.text else {
            return
        }
        guard let password = pwField.text else {
            return
        }
        if id == DEV_ID && password == DEV_PW {
            loginState = .tried
            return tryLoginWithAccessToken(accessToken: self.DEV_API_TOKEN)
        }
        loginState = .tried
        let loginQuery : String = "$('#uid').val('\(String(describing: id))');\n$('#upw').val('\(String(describing: password))');\n$('#login_btn').click();"
        webView.evaluateJavaScript(loginQuery)
    }
    
    private func tryLoginWithAccessToken(accessToken : String) {
        stuffNeedUpdate = true
        historyNeedToUpdate = true
        let loginResult = postAccessToken(accessToken : accessToken, exceptionHandler: basicHttpExceptionHandler())
        if(tokenExpired) {
            checkTokenExpiredAndSendAlert(viewController : self)
            return
        }
        
        if (loginResult) {
            guard let serverToken = curUser.token else {
                presentLoginFailAlert()
                return
            }
            loginState = .success
            UserDefaults.standard.set(serverToken, forKey: "user-token")
            UserDefaults.standard.set(false, forKey: "login-to-admin-mode")
            self.navigationController?.isNavigationBarHidden = false
            performSegue(withIdentifier: "SG_backToMain", sender: nil)
            return
        }
        presentLoginFailAlert()
        return
    }
}

extension UserController: WKUIDelegate {
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            loadWebPage(LOGIN_URL)
            return
        }
        let stringUrl = url.absoluteString
        if (loginState == .tried) {
            if (stringUrl == FIRST_URL) {
                togleAgree(flag: false)
                return
            }
            if (stringUrl.contains("#access_token=")) {
                guard let beforeStartIndex = stringUrl.firstIndex(of: "="), let lastIndex = stringUrl.firstIndex(of: "&")
                else {
                    presentLoginFailAlert()
                    return
                }
                let startIndex = stringUrl.index(after: beforeStartIndex)
                let accessToken = String(stringUrl[startIndex..<lastIndex])
                tryLoginWithAccessToken(accessToken: accessToken)
                return
            }
            presentLoginFailAlert()
            return
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "확인", style: .cancel) { _ in
            completionHandler()
        }
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
