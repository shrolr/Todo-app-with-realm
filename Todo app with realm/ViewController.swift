//
//  ViewController.swift
//  Todo app with realm
//
//  Created by samet sahin on 18.09.2017.
//  Copyright © 2017 samet sahin. All rights reserved.
//

import UIKit
import RealmSwift
import M13Checkbox
class mainVC : UIViewController  {
    
    
    @IBOutlet weak var table : UITableView!
    @IBOutlet weak var NewTaskView: UIView!
    @IBOutlet weak var newTaskContainerView: UIView!
    @IBOutlet weak var newTaskTextField: UITextField!
    @IBOutlet weak var dateSwtich : UISwitch!
    @IBOutlet weak var prioritySwitch : UISwitch!
    @IBOutlet weak var ascendingSwitch : UISwitch!
    @IBOutlet weak var sortingView : UIView!
    
    var newTaskViewOriginY :CGFloat = 0.0 // When keyboard shows up I'm arranging textfield position according to keyboard
    let realm = try! Realm()
    let searchController = UISearchController(searchResultsController: nil)
    var selectedItem : todoItem!
    var filteredToDoITems = [todoItem]()
    var toDoItems : Results<todoItem>!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        
        
        // delegates and datasources
        table.dataSource = self
        table.delegate = self
        newTaskTextField.delegate = self
        
        // retrieving data from database before initializing search controller otherwise app will crash
        toDoItems = { realm.objects(todoItem.self) } ()
        
        
        // İnitializing searchbar controller and setting default values
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        table.tableHeaderView = searchController.searchBar
        searchController.searchBar.searchBarStyle = .minimal
        
        // Editing UI
        sortingView.layer.borderColor = UIColor.black.cgColor
        sortingView.layer.borderWidth = 1
        
        
        // When keyboard shows up I'm arranging textfield position according to keyboard
        newTaskViewOriginY = NewTaskView.frame.origin.y
        
    }
    
  
    
    @IBAction func Addnewtask(_ sender: UIButton) {
        newTaskContainerView.alpha = 1
        newTaskTextField.becomeFirstResponder()
    }
    
    
    @IBAction func dateSwitch(_ sender: UISwitch) {
        
        if sender.isOn
        {
            prioritySwitch.setOn(false, animated: true)
        }
    }
    
    @IBAction func showSortingView(_ sender: UIButton) {
        if sortingView.alpha == 1 {
            UIView.animate(withDuration: 0.3, animations: {
                self.sortingView.alpha = 0
            })
        }
        else {
            searchController.isActive = false
            UIView.animate(withDuration: 0.3, animations: {
                self.sortingView.alpha = 1
            })
        }
    }
    
    @IBAction func prioritySwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn
        {
            dateSwtich.setOn(false, animated: true)
        }
    }
    
    
    
    
    @IBAction func sortToDoItems(_ sender: UIButton) {
        
        if prioritySwitch.isOn {
            toDoItems = { realm.objects(todoItem.self).sorted(byKeyPath: "priorityLevel.level", ascending: ascendingSwitch.isOn) } ()
        }
        else if dateSwtich.isOn
        {
            toDoItems = { realm.objects(todoItem.self).sorted(byKeyPath: "shouldBeCompletedAt", ascending: ascendingSwitch.isOn) } ()
        }
        else {
            toDoItems = { realm.objects(todoItem.self) } ()
        }
        table.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"
        {
            if let vc = segue.destination as? toDoDetailsTableViewController
            {
                vc.setupView(todoObject: selectedItem)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toDoItems = { realm.objects(todoItem.self) } ()
        table.reloadData()        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}


extension mainVC {
    
    func addNewToDoItem(name :String)
    {
        let newToDo = todoItem()
        newToDo.name = name
        try! realm.write {
            realm.add(newToDo)
        }
        table.reloadData()
    }
    
    
    
    
    
}

//Implementing search bar and setting necessary functions

extension mainVC : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredToDoITems = toDoItems.filter({( todos : todoItem) -> Bool in
            
            return todos.name.lowercased().contains(searchText.lowercased())
        })
        
        table.reloadData()
    }
    
}


// Keyboard stuff

extension mainVC : UITextFieldDelegate {
    
    // When user hit done key its calling a function to create to do object
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newTaskTextField
        {
            if textField.text != "" {
                addNewToDoItem(name: textField.text!)
                textField.text = ""
                textField.resignFirstResponder()
            }
            
        }
        return true
    }
    
    
    // registering keyboard notifications for arranging textfield position
    func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWasShown(_ notificiation : NSNotification)
    {
        if let keyboardSize = (notificiation.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.NewTaskView.frame.origin.y == newTaskViewOriginY{
                UIView.animate(withDuration: 0.3, animations: {
                    self.NewTaskView.frame.origin.y -= keyboardSize.height
                })
            }
        }
    }
    func keyboardWillBeHidden(_ notificiation : NSNotification)
    {
        if let keyboardSize = (notificiation.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.NewTaskView.frame.origin.y != newTaskViewOriginY{
                UIView.animate(withDuration: 0.3, animations: {
                    self.NewTaskView.frame.origin.y += keyboardSize.height
                    
                })
                
                if newTaskContainerView.alpha == 1
                {
                    newTaskContainerView.alpha = 0
                }
            }
        }
    }
    
}


// table view stuff

extension mainVC : UITableViewDelegate ,UITableViewDataSource
{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredToDoITems.count
        }
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? toDoTableViewCell
        {
            if isFiltering()
            {
                 cell.setupView(filteredToDoITems[indexPath.row])
                return cell
            }
             cell.setupView(toDoItems[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = toDoItems[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: selectedItem)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            
            let alertController = UIAlertController(title: "Do you want to delete it", message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                
                try! self.realm.write {
                    self.realm.delete(self.toDoItems[indexPath.row])
                }
                self.table.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                self.table.reloadData()
            })
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            alertController.popoverPresentationController?.sourceView = self.view
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
}


