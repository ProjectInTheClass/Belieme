//
//  StuffDetailController.swift
//  Belieme
//
//  Created by 이석환 on 2022/04/22.
//

import UIKit

/*
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
 */


class StuffDetailController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var stuffArray: Array<String> = []
    var paramCount: Int = 0
    var paramImage: String = ""
    var paramName: String = ""
    
    //let data = stuffsData[this.tag]
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var stuffImage: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stuffName: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    func Init(){
        self.stuffName.text = paramName
        self.stuffImage.text = paramImage
        
        for i in 1...paramCount{
            let textValue = stuffName.text! + "#" + String(i)
            self.stuffArray.append(textValue)
        }
        
    
    }
    
    
   
    @IBAction func stuffImageChanged(_ sender: UITextField) {
        self.stuffImage.addTarget(self, action: #selector(self.stuffImageChanged(_:)), for: .editingChanged)
        
        print(stuffImage.text!)

    
    }
    @IBAction func stuffNameChanged(_ sender: UITextField) {
       
        
        self.stuffName.addTarget(self, action: #selector(self.stuffNameChanged(_:)), for: .editingChanged)

        print(stuffName.text!)
    
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        //커서 깜빡이는거 없애기
        stuffImage.tintColor = UIColor.clear
        stuffName.tintColor = UIColor.clear
        
        print(stuffImage.text!)
        print(stuffName.text!)
        
        
    }
    
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let textValue = stuffName.text! + "#" + String(stuffArray.count + 1)
        self.stuffArray.append(textValue)
       // self.tableView.reloadData()
        
        
        let indexPath = IndexPath(row: self.stuffArray.count - 1, section: 0)
       
        tableView.beginUpdates()
        
        self.tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.bottom)
        
        tableView.endUpdates()
         
        print(self.stuffArray)
            
              
        
    }
    
    func deleteCell(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            stuffArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
            
       
    
   
    //아이템 수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stuffArray.count
        }
     
    //설정한 cell 리턴
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        
        cell.textLabel?.text = stuffArray[indexPath.row]
                
        return cell
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            stuffArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.beginUpdates()
            
        } else if editingStyle == .insert {
          
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
            return "분실"
        }
    
    
    func addDoneButton(){
        stuffName.addDoneButtonOnKeyboard()
        stuffImage.addDoneButtonOnKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        addDoneButton()
        
        // Do any additional setup after loading the view.
    
        //datasource delegate을 Viewcontroller로 설정
        tableView.dataSource = self
        tableView.delegate = self
    }


}

extension UITextField{
    
    
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
