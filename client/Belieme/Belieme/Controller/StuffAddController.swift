//
//  StuffAddController.swift
//  Belieme
//
//  Created by yelin on 2022/05/16.
//

import Foundation
import UIKit

var addFlag : Bool = false

class StuffAddController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate
{
    var num: [String] = []
    let numPicker = UIPickerView()
    var fCurTextfieldBottom: CGFloat = 0.0 //키보드가 텍스트필드 가리는지 확인하기 위한 변수
    
    
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var stuffIcon: UITextField!
    @IBOutlet weak var stuffLabel: UITextField!
    @IBOutlet weak var stuffNum: UITextField!
    
    @IBOutlet weak var stackIcon: UIStackView!
    @IBOutlet weak var stackLabel: UIStackView!
    @IBOutlet weak var stackNum: UIStackView!
    @IBOutlet weak var finalStack: UIStackView!
    @IBOutlet weak var downView: UIView!
    
    @IBAction func iconClicked(_ sender: UITextField) {
        fCurTextfieldBottom = downView.frame.origin.y+finalStack.frame.origin.y+stackIcon.frame.origin.y + sender.frame.height
        stuffLabel.isUserInteractionEnabled = false
        stuffNum.isUserInteractionEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
    }
    @IBAction func labelClicked(_ sender: UITextField) {
        fCurTextfieldBottom = downView.frame.origin.y+finalStack.frame.origin.y+stackLabel.frame.origin.y + sender.frame.height
      //  stackIcon.isUserInteractionEnabled = false
        stuffNum.isUserInteractionEnabled = false
    }
   
    @IBAction func numClicked(_ sender: UITextField) {
        fCurTextfieldBottom = downView.frame.origin.y+finalStack.frame.origin.y+stackNum.frame.origin.y + sender.frame.height
     //   stackIcon.isUserInteractionEnabled = false
        stuffLabel.isUserInteractionEnabled = false
    }
    

    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        guard let emoji = stuffIcon.text else {
            return
        }
        guard let name = stuffLabel.text else {
            return
        }
        guard let numText = numTextField.text else {
            return
        }
        guard let amount = Int(numText) else {
            self.showToast(message: "숫자를 등록해 주세요.", font: .systemFont(ofSize: 12.0))
            return
        }
        if (!emoji.isSingleEmoji) {
            self.showToast(message: "이모지를 등록해 주세요.", font: .systemFont(ofSize: 12.0))
            return
        }
        if (name.count <= 0 || name.count >= 10) {
            self.showToast(message: "물품명을 등록해 주세요.", font: .systemFont(ofSize: 12.0))
            return
        }
        let result : Bool = createNewStuff(name: name, emoji: emoji, amount: amount, exceptionHandler: basicHttpExceptionHandler())
        if(tokenExpired) {
            checkTokenExpiredAndSendAlert(viewController : self)
            return
        }
        
        let alert = UIAlertController(
            title : (result) ? "물품이 성공적으로 생성되었습니다." : "물품 생성에 실패하였습니다. 잠시후 다시 시도해주세요.",
            message: nil,
            preferredStyle : .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default) { UIAlertAction in
            if (result) {
                addFlag = true
                self.presentingViewController?.dismiss(animated: true)
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return num[row]
        
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return num.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.numTextField.text = self.num[row]
        
    }

   
    func Init(){
        numPicker.delegate = self
        stuffIcon.delegate = self
        stuffLabel.delegate = self
        stuffNum.delegate = self
        
        numPicker.dataSource = self
        for i in 1..<100 {
                  num.append(String(i))
               }
        numTextField.inputView = numPicker
        
        stuffIcon.placeholder = "이모지 등록"
        stuffLabel.placeholder = "물품이름 등록"
        stuffNum.placeholder = "물품개수 등록"
        stuffIcon.delegate = self
        
        
//        stuffNum.returnKeyType = .done
//        stuffIcon.returnKeyType = .done
//        stuffLabel.returnKeyType = .done
    }
    
    func setToolbar() { // toolbar를 만들어준다.
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        
        
        // 만들어줄 버튼 // flexibleSpace는 취소~완료 간의 거리를 만들어준다.
        let doneBT = UIBarButtonItem(title: "선택", style: .done, target: self, action: #selector(self.donePicker))
        doneBT.tintColor = .systemBlue
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        
        // 만든 아이템들을 세팅해주고
        toolBar.setItems([flexibleSpace,doneBT], animated: false)
        toolBar.isUserInteractionEnabled = true
        // 악세사리로 추가한다.
        numTextField.inputAccessoryView = toolBar
        
    }
    
    // "완료" 클릭 시 데이터를 textfield에 입력 후 입력창 내리기
    @objc func donePicker() {
        let row = self.numPicker.selectedRow(inComponent: 0)
        self.numPicker.selectRow(row, inComponent: 0, animated: false)
        self.numTextField.text = self.num[row]
        self.numTextField.resignFirstResponder()
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        textField.resignFirstResponder()  //if desired
//
//        return true
//    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        Init()
        setToolbar()
        addKeyboardNotifications()

    }
    
    func addDoneButton() {
        stuffLabel.addDoneButtonOnKeyboard()
        stuffIcon.addDoneButtonOnKeyboard()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButton()
        addKeyboardNotifications()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        stuffIcon.isUserInteractionEnabled = true
        if(textField == stuffIcon){
                guard let text = textField.text else { return true }
                let newLength = text.count + string.count - range.length
                    return newLength <= 1
            }else{
                return true
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
   
    // 키보드가 나타났다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillShow(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 올려준다.
        if let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                   if fCurTextfieldBottom <= self.view.frame.height - keyboardSize.height {
                       return
                   }
                   if self.view.frame.origin.y == 0 {
                       self.view.frame.origin.y += 20
                       self.view.frame.origin.y -= keyboardSize.height
                      // self.view.frame.origin.y -= 200
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
    
    @objc func keyboardDidChangeFrame(_ noti: NSNotification) {
        //if let keyboard = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] {
            
            self.view.frame.origin.y -= 25
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //화면 터치시 키보드 내려가게끔
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
        stuffIcon.isUserInteractionEnabled = true
        stuffNum.isUserInteractionEnabled = true
        stuffLabel.isUserInteractionEnabled = true
    }
}
