//
//  QuestionController.swift
//  Belieme
//
//  Created by mac on 2022/04/14.
//

import UIKit
import SwiftSMTP
import LoggerAPI

class QuestionController: UIViewController, UITextViewDelegate,UITextFieldDelegate {

    var isError : Bool = false
    var alertTitle = "문의등록완료"
    var message = ""
    var fCurTextfieldBottom: CGFloat = 0.0 //키보드가 텍스트필드 가리는지 확인하기 위한 변수
 
    @IBOutlet weak var AskUserEmail: UITextField!
    @IBOutlet weak var AskTitle: UITextField!
    @IBOutlet weak var AskContent: UITextView!
    var textviewplaceholder: String = "문의 내용을 입력해주세요.(최대 1000자)"
    
    
    //등록 버튼 눌렀을 때 사용자가 입력한 정보 출력
    @IBAction func SubmitButtonClicked(_ sender: Any) {
        if (!AskUserEmail.text!.isValidEmail) {
            showToast(message: "이메일 형식을 맞춰주세요.", font: .systemFont(ofSize: 10.0))
            return
        }
        if (AskTitle.text!.count < 2) {
            showToast(message: "제목은 두 글자를 넘겨주세요.", font: .systemFont(ofSize: 10.0))
            return
        }
        if (AskContent.text!.count < 5 || AskContent.text! == textviewplaceholder) {
            showToast(message: "문의 내용은 다섯 글자를 넘겨주세요.", font: .systemFont(ofSize: 8.0))
            return
        }
        
        let mail_to = Mail.User(name: "mail_to", email: "belieme.hyu@gmail.com")

        let mail = Mail(
            from: mail_from,
            to: [mail_to],
            subject: AskTitle.text!,
            text: AskContent.text! + "\n" + AskUserEmail.text!
        )
        
        smtp.send(mail) { (error) in
            if let error = error {
                print(error)
            }
        }
        
            
        let alertMessage = UIAlertController(
            title: self.alertTitle ,
            message: self.message,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default){ _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertMessage.addAction(okAction)
        self.present(alertMessage, animated: true, completion: nil)
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        
        AskUserEmail.delegate = self
        AskContent.delegate = self
        AskTitle.delegate = self
        //placeholder 구현을 위함
        //나 자신이 UITextViewDelegate을 준수하고 있음을 밝힘
        
        TextRadius()     //textView 모서리 둥글게
        addDoneButton()  //키보드 위에 '완료' 버튼 추가
       // TitleLabel.adjustsFontSizeToFitWidth = true
    
        AskUserEmail.keyboardType = .emailAddress
    }
       
    //textview 모서리 둥글게
    func TextRadius(){
        
        AskContent.clipsToBounds = true;
        AskContent.layer.cornerRadius = 8.0;
        AskContent.layer.borderColor = UIColor.systemGray5.cgColor
//        AskTitle.layer.borderColor = UIColor.systemGray6.cgColor
//        AskUserEmail.layer.borderColor = UIColor.systemGray6.cgColor

    }

    /*func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray2{ //placeholder인 경우
//            if textView == AskUserEmail{
//                AskUserEmail.text = nil           //placeholder(회색 글자) 지우고
//                AskUserEmail.textColor = .black  //text 검정색으로
//            }
//            if textView == AskTitle{
//                AskTitle.text = nil
//                AskTitle.textColor = .black
//            }
            if textView == AskContent{
                AskContent.text = nil
                AskContent.textColor = .black
            }
        }
        
       // fCurTextfieldBottom = textView.frame.origin.y + textView.frame.height
    }*/
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.textColor == .systemGray2{ //placeholder인 경우
           
            if textView == AskContent{
                AskContent.text = nil
                AskContent.textColor = .black
            }
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty ||  textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                if(textView==AskContent){
                    AskContent.text = "문의 내용을 입력해주세요.(최대 1000자)"
                }
                textView.textColor = .systemGray2
            }
    }
    
    //AskContent의 글자 수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newLength = AskContent.text.count - range.length + text.count
        if newLength > 1000 {
            return false
        }
        return true
    }
    
   
    func addDoneButton(){
        AskUserEmail.addDoneButtonOnKeyboard()
        AskTitle.addDoneButtonOnKeyboard()
        AskContent.addDoneButtonOnKeyboard()
    }
    
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: Notification) {
        if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    if fCurTextfieldBottom <= self.view.frame.height - keyboardSize.height {
                        return
                    }
                    if self.view.frame.origin.y == 0 {
                        self.view.frame.origin.y += 20
                        self.view.frame.origin.y -= keyboardSize.height
                    }
                               
        }
    }
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 내려준다.
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        
    }
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
           // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
     
    }
    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
               
    //화면 터치시 키보드 내려가게끔
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
}



extension UITextView{
    
    
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

