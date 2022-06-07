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
    
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var stuffIcon: UITextField!
    @IBOutlet weak var stuffLabel: UITextField!
    @IBOutlet weak var stuffNum: UITextField!
    
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
        let result : Bool = createNewStuff(name: name, emoji: emoji, amount: amount)
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

    @IBOutlet weak var addView: UIView!
    func Init(){
        numPicker.delegate = self
        numPicker.dataSource = self
        for i in 1..<100 {
                  num.append(String(i))
               }
        numTextField.inputView = numPicker
        
        stuffIcon.placeholder = "이모지 등록"
        stuffLabel.placeholder = "물품이름 등록"
        stuffNum.placeholder = "물품개수 등록"
        stuffIcon.delegate = self
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        Init()
        setToolbar()
    }
    
    func addDoneButton() {
        stuffLabel.addDoneButtonOnKeyboard()
        stuffIcon.addDoneButtonOnKeyboard()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButton()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
            return newLength <= 1
        }

}
