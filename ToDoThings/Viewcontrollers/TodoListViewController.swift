//
//  ViewController.swift
//  ToDoThings
//
//  Created by User on 28/05/18.
//  Copyright © 2018 Kranthikiran. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController
{
    var textField = UITextField()
    var itemArray: Results<Item>?
    
    let realm = try! Realm()
    
    // this calls only when the selectedCategory in the categoryVC has some value
    var selectedCategory: Categories? {
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // loadItems()
    }
    
    //MARK - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray?.count ?? 1
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItem", for: indexPath)
        
        if let item = itemArray?[indexPath.row]
        {
        cell.textLabel?.text = itemArray?[indexPath.row].title
        cell.accessoryType = item.done ? .checkmark : .none
        }else
        {
            cell.textLabel?.text = "Item not yet added"
        }
        //ternery operator we can write if conditions like this
        
      //  cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
  //  MARK - Tableview delegate methods
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let items = itemArray?[indexPath.row]{
        do{
            try realm.write {
            realm.delete(items)
            //items.done = !items.done
            }
        }catch{
            print("Error saving done status \(error)")
        }
    tableView.reloadData()
    tableView.deselectRow(at: indexPath, animated: true)
    }
}
    // MARK - add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add items to TodoList", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add NewItem", style: .default) { (alert) in
            
    //what should happen when user clicks the add button on our UIAlert
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = self.textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Erorr in saving the newitems \(error)")
                    
                }
            }
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
    
    
    func save(saveItems: Item){
        do{
            try realm.write {
                realm.add(saveItems)
            }
        }catch{
            print("Error in saving the data \(error)")
        }
    }

//loads the data everttime we close and open the app
   func loadItems(){
    
    itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//
//        if let additionalPredicate = predicate{
//
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
//        } else{
//            request.predicate = categoryPredicate
//        }
//        do{
//        itemArray = try context.fetch(request)
//        }catch
//        {
//            print("Error in loading the data \(error)")
//        }
        tableView.reloadData()
    }
}
//MARK:-
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {

                searchBar.resignFirstResponder()
            }
        }
    }
}

