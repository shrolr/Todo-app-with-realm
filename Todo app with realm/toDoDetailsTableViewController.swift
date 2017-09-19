//
//  toDoDetailsTableViewController.swift
//  Todo app with realm
//
//  Created by samet sahin on 19.09.2017.
//  Copyright © 2017 samet sahin. All rights reserved.
//

import UIKit
import RealmSwift
import M13Checkbox
class toDoDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var reminderDatePicker : UIDatePicker!
    @IBOutlet weak var priorityPickerView : UIPickerView!
    @IBOutlet weak var listPickerView : UIPickerView!
    @IBOutlet weak var priorityLabel : UILabel!
    @IBOutlet weak var reminderLabel : UILabel!
    @IBOutlet weak var listLabel : UILabel!
    @IBOutlet weak var nameTextField : UITextField!
    @IBOutlet weak var completedCheckMark : M13Checkbox!
    @IBOutlet weak var priorityButton: UIButton!
    @IBOutlet weak var reminderButton: UIButton!
    
    
    let realm = try! Realm()
    let priorityPickerViewTag = constants.pickerViewTag
    var lists :Results<list>!
    var priorities : Results<priority>!
    let priorityPickerCellIndexPath = IndexPath(row: 3, section: 1)
    let listPickerCellIndexPath = IndexPath(row: 5, section: 1)
    let remainderDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    var isPriorityPickerShown : Bool = false
    var isListPickerViewShown : Bool = false
    var isReminderDatePickerShown : Bool = false
    var selectedToDoItem : todoItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // delegates and datasources

        priorityPickerView.delegate = self
        priorityPickerView.dataSource = self
        listPickerView.delegate = self
        listPickerView.dataSource = self
        nameTextField.delegate = self
        
        // there are two pickerview so I need  to tag one of them 
        // 
        priorityPickerView.tag = constants.pickerViewTag
       
        //retrieving data from realm
        priorities  = { realm.objects(priority.self) }()
        lists = {realm.objects(list.self)} ()
        
        // Updating User interface according to Object
        updateUIAccordingToObject()
        
    }
    
    
    func setupView (todoObject : todoItem)
    {
        selectedToDoItem = todoObject
    }
    
    
    func updateUIAccordingToObject() {
        
        
        
        if selectedToDoItem.priorityLevel != nil
        {
            priorityLabel.isHidden = false
            priorityButton.isHidden = false
            priorityLabel.text = selectedToDoItem.priorityLevel.level
        }
        else {
            priorityButton.isHidden = true
            priorityLabel.isHidden = true
            
        }
        if selectedToDoItem.shouldBeCompletedAt != 0
        {
            reminderButton.isHidden = false
            reminderLabel.isHidden = false
            let date = Date(timeIntervalSinceReferenceDate: selectedToDoItem.shouldBeCompletedAt)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM HH:mm"
            reminderLabel.text = dateFormatter.string(from: date)
        }
        else{
            reminderButton.isHidden = true
            reminderLabel.isHidden = true
            
        }
        if selectedToDoItem.list != nil {
            listLabel.isHidden = false
            listLabel.text = selectedToDoItem.list.name
        }
        else{
            listLabel.isHidden = true
            
        }
        nameTextField.text = selectedToDoItem.name
        switch selectedToDoItem.completed{
        case true:
            completedCheckMark.setCheckState(.checked, animated: true)
        case false:
            completedCheckMark.setCheckState(.unchecked, animated: true)
        }
    }
    
    
    
    // IBactions
    
    
    // removes reminder from object
    @IBAction func removeReminder(_ sender: Any) {
        try! realm.write {
            selectedToDoItem.shouldBeCompletedAt = 0
        }
        
        updateUIAccordingToObject()
    }
    // removes priority from object
    @IBAction func removePriority(_ sender: UIButton) {
        try! realm.write {
            selectedToDoItem.priorityLevel = nil
        }
        
        updateUIAccordingToObject()
    }
    
    // update reminder dates
    @IBAction func selectedDateChanged(_ sender: UIDatePicker) {
        
        try! realm.write {
            selectedToDoItem.shouldBeCompletedAt = reminderDatePicker.date.timeIntervalSinceReferenceDate
        }
        updateUIAccordingToObject()
        
    }
    
    
    
    
    @IBAction func checkBoxChanged(_ sender: M13Checkbox) {
        try! realm.write {
            print(sender.checkState.rawValue)
            switch sender.checkState.rawValue {
            case "Checked":
                selectedToDoItem.completed = true
            case "Unchecked":
                selectedToDoItem.completed = false
            default:
                break
            }
        }
    }
    
}


// Arranging table cells for better UX
extension toDoDetailsTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath.section , indexPath.row) {
        case (remainderDatePickerCellIndexPath.section , remainderDatePickerCellIndexPath.row):
            if isReminderDatePickerShown {
                return reminderDatePicker.frame.height
            }
            else
            {
                return 0.0
            }
        case (priorityPickerCellIndexPath.section, priorityPickerCellIndexPath.row):
            if isPriorityPickerShown
            {
                return priorityPickerView.frame.height
            }
            else {
                return 0.0
            }
        case (listPickerCellIndexPath.section,listPickerCellIndexPath.row):
            if isListPickerViewShown {
                return listPickerView.frame.height
            }
            else
            {
                return 0.0
            }
        default:
            return 44
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section , indexPath.row) {
        case (remainderDatePickerCellIndexPath.section , remainderDatePickerCellIndexPath.row - 1):
            if isReminderDatePickerShown {
                isReminderDatePickerShown = false
            }
            else
            {
                isReminderDatePickerShown = true
                isPriorityPickerShown = false
                isListPickerViewShown = false
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case (priorityPickerCellIndexPath.section, priorityPickerCellIndexPath.row - 1):
            if isPriorityPickerShown {
                isPriorityPickerShown =  false
            }
            else {
                isPriorityPickerShown = true
                isReminderDatePickerShown = false
                isListPickerViewShown = false
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
        case (listPickerCellIndexPath.section,listPickerCellIndexPath.row - 1):
            if isListPickerViewShown {
                isListPickerViewShown = false
            }
            else
            {
                isPriorityPickerShown = false
                isReminderDatePickerShown = false
                isListPickerViewShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
        
    }
    

}


//
extension toDoDetailsTableViewController : UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            try! realm.write {
                selectedToDoItem.name = textField.text!
            }
            textField.resignFirstResponder()

        }
        return true
    }
    
    
    
}


// arranging picker view
extension toDoDetailsTableViewController : UIPickerViewDataSource , UIPickerViewDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == priorityPickerViewTag
        {
            return priorities.count
        }
        else
        {
            return lists.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == priorityPickerViewTag
        {
            return priorities[row].level
        }
        else
        {
            return lists[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        try! realm.write {
            if pickerView.tag == priorityPickerViewTag
            {
                selectedToDoItem.priorityLevel = priorities[row]
            }
            else {
                selectedToDoItem.list = lists[row]
            }
        }
        updateUIAccordingToObject()
        
        
        
    }
    
    
    
}
