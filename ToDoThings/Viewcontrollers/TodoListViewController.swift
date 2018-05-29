//
//  ViewController.swift
//  ToDoThings
//
//  Created by User on 28/05/18.
//  Copyright © 2018 Kranthikiran. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController
{
    var textField = UITextField()
    let defaults = UserDefaults.standard
    
    var itemArray = [Item]()
   // var itemArray = ["Find Eggs","LeafyVegatables","Chicken","Ben", "Ivy", "Jordell","Maxime","Shakia","William","periwinkle","rose","moss"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find dory"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find nemo"
        itemArray.append(newItem3)
        
        if let items = UserDefaults.standard.array(forKey: "TodoListArray") as? [Item]
        {
            itemArray = items
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItem", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //ternery operator we can write if conditions like this
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
//        if itemArray[indexPath.row].done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        return cell
    }
    
  //  MARK - Tableview delegate methods
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    tableView.reloadData()
    tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add items to TodoList", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add NewItem", style: .default) { (alert) in
            //what should happen when user clicks the add button on our UIAlert
            
            let newItem = Item()
            newItem.title = self.textField.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
        self.textField = alertTextField
            //print(alertTextField.text)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    

}

