//
//  toDoTableViewCell.swift
//  Todo app with realm
//
//  Created by samet sahin on 18.09.2017.
//  Copyright © 2017 samet sahin. All rights reserved.
//

import UIKit
import M13Checkbox
import RealmSwift
class toDoTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBox: M13Checkbox!
    @IBOutlet weak var title: UILabel!
    var todoObject : todoItem!
    let realm = try! Realm()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func setupView(_ _todoObject : todoItem)
    {
        // setting title and checkbox's state
        todoObject = _todoObject
        title.text = todoObject.name
        switch todoObject.completed{
        case true:
            checkBox.setCheckState(.checked, animated: true)
        case false:
            checkBox.setCheckState(.unchecked, animated: true)
        }
    }
    
    

    @IBAction func stateChanged(_ sender: M13Checkbox) {
        
        
        // checking checkbox state and editing to do's completed state
        
        try! realm.write {
            print(sender.checkState.rawValue)
            switch sender.checkState.rawValue {
            case "Checked":
                todoObject.completed = true
            case "Unchecked":
                todoObject.completed = false
            default:
                break
            }
        }
    }
    
}
