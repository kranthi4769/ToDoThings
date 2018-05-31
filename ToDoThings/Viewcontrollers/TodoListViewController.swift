//
//  ViewController.swift
//  ToDoThings
//
//  Created by User on 28/05/18.
//  Copyright © 2018 Kranthikiran. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController
{
    var textField = UITextField()
    var itemArray = [Item]()
    
    // this calls only when the selectedCategory in the categoryVC has some value
    var selectedCategory: Categories? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // loadItems()
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
        return cell
    }
    
  //  MARK - Tableview delegate methods
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
    
    context.delete(itemArray[indexPath.row])
    itemArray.remove(at: indexPath.row)
    //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    saveItems()
    
    tableView.reloadData()
    tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add items to TodoList", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add NewItem", style: .default) { (alert) in
            
            //what should happen when user clicks the add button on our UIAlert
            
            let newItem = Item(context : self.context)
            newItem.title = self.textField.text!
            newItem.done = false
            
            //property parent category is came from the datamodel we are created to link the two entities
            
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
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
    
    func saveItems(){
        do{
            try context.save()
        }catch
        {
            print("Error in saving the context \(error)")
        }
    }
    //loads the data everttime we close and open the app
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPredicate = predicate{
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else{
            request.predicate = categoryPredicate
        }
        do{
        itemArray = try context.fetch(request)
        }catch
        {
            print("Error in loading the data \(error)")
        }
        tableView.reloadData()
    }
}
//MARK:-
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
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
