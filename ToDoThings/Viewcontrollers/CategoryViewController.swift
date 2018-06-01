//
//  CategoryViewController.swift
//  ToDoThings
//
//  Created by User on 31/05/18.
//  Copyright © 2018 Kranthikiran. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var textField = UITextField()
    var categoryArray: Results<Categories>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Category to ToDoThings", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (alert) in
            
            let newCategory = Categories()
            newCategory.name = self.textField.text!
            self.save(category: newCategory)
            
            self.tableView.reloadData()
                        
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            self.textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // if the category array may be nil then return with 1 row
        return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItem", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "Categories not added yet"
        
        return cell
    }

    //MARK: - Tableview delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.reloadData()
        tableView.separatorColor = UIColor.red
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // to pas the data between the VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
       if let selectedIndexpath = tableView.indexPathForSelectedRow{
        destinationVC.selectedCategory = categoryArray?[selectedIndexpath.row]
        }
    }
    //MARK: - Data Manupulation Methods
    // categories here is the class
    func save(category: Categories){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error in saving the data \(error)")
        }
    }
    
    func loadData(){
    
     categoryArray = realm.objects(Categories.self)
        
        tableView.reloadData()
   }

}
