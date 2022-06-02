//
//  StuffAddController.swift
//  Belieme
//
//  Created by yelin on 2022/05/16.
//

import Foundation
import UIKit

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
        
        //물품 추가
        print("물품아이콘:"+stuffIcon.text!)
        print("물품이름:"+stuffLabel.text!)
        print("물품개수:"+numTextField.text!)
        
        self.presentingViewController?.dismiss(animated: true)
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
    
  

   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Init()
        setToolbar()
       
    }
    


}
