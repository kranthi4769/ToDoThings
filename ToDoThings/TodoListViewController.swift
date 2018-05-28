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
    
    let itemArray = ["Find Eggs","LeafyVegatables","Chicken"]

    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
  //  MARK - Tableview delegate methods
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
    
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
    }else{
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    
    
    
    
    tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

