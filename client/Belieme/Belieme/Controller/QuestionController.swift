//
//  QuestionController.swift
//  Belieme
//
//  Created by mac on 2022/04/14.
//

import UIKit
import SwiftSMTP
import LoggerAPI

class QuestionController: UIViewController, UITextViewDelegate {

    var isError : Bool = false
    var alertTitle = "문의등록완료"
    var message = ""
   
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var AskUserEmail: UITextView!
    @IBOutlet weak var AskTitle: UITextView!
    @IBOutlet weak var AskContent: UITextView!
    
    
    //등록 버튼 눌렀을 때 사용자가 입력한 정보 출력
    @IBAction func SubmitButtonClicked(_ sender: Any) {
        if (!AskUserEmail.text.isValidEmail) {
            showToast(message: "이메일 형식을 맞춰주세요.", font: .systemFont(ofSize: 10.0))
            return
        }
        let mail_to = Mail.User(name: "mail_to", email: "belieme.hyu@gmail.com")

        let mail = Mail(
            from: mail_from,
            to: [mail_to],
            subject: AskTitle.text,
            text: AskContent.text + "\n" + AskUserEmail.text
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
        
    }
       
    //textview 모서리 둥글게
    func TextRadius(){
        
        AskContent.clipsToBounds = true;
        AskContent.layer.cornerRadius = 10.0;
        
        AskUserEmail.clipsToBounds = true;
        AskUserEmail.layer.cornerRadius = 10.0;
        
        AskContent.clipsToBounds = true;
        AskTitle.layer.cornerRadius = 10.0;
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray2{ //placeholder인 경우
            if textView == AskUserEmail{
                AskUserEmail.text = nil           //placeholder(회색 글자) 지우고
                AskUserEmail.textColor = .black  //text 검정색으로
            }
            if textView == AskTitle{
                AskTitle.text = nil
                AskTitle.textColor = .black
            }
            if textView == AskContent{
                AskContent.text = nil
                AskContent.textColor = .black
            }
        }
       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
            if textView.text.isEmpty ||  textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{ //아무것도 쓰지 않았거나 개행,공백 들어간경우
                
                //다시 placeHolder(회색글자) 삽입
                if(textView==AskUserEmail){
                    AskUserEmail.text = "이메일 주소를 입력해주세요."
                }
                if(textView==AskContent){
                    AskContent.text = "문의 내용을 입력해주세요.(최대 100자)"
                }
                if(textView==AskTitle){
                    AskTitle.text = "제목을 입력해주세요."
                }
    
                textView.textColor = .systemGray2
            }
        
    }
    
    //AskContent의 글자 수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newLength = AskContent.text.count - range.length + text.count
        if newLength > 100 {
            return false
        }
        return true
    }
    
   
    func addDoneButton(){
        AskUserEmail.addDoneButtonOnKeyboard()
        AskTitle.addDoneButtonOnKeyboard()
        AskContent.addDoneButtonOnKeyboard()
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

