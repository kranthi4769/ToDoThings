//
//  CategoryViewController.swift
//  ToDoThings
//
//  Created by User on 31/05/18.
//  Copyright © 2018 Kranthikiran. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var textField = UITextField()
    var categoryArray = [Categories]()
    
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Category to ToDoThings", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (alert) in
            
            let newCategory = Categories(context: self.context)
            newCategory.name = self.textField.text!
            self.categoryArray.append(newCategory)
            self.saveData()
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
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItem", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }

    //MARK: - Tableview delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
       // context.delete(categoryArray[indexPath.row])
      //  categoryArray.remove(at: indexPath.row)
        saveData()

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // to pas the data between the VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
       if let selectedIndexpath = tableView.indexPathForSelectedRow{
        destinationVC.selectedCategory = categoryArray[selectedIndexpath.row]
        }
    }
    //MARK: - Data Manupulation Methods
    func saveData(){
        do{
         try context.save()
        }catch{
            print("Error in saving the data \(error)")
        }
    }
    
    func loadData(with request: NSFetchRequest<Categories> = Categories.fetchRequest()){
        do{
       categoryArray =  try context.fetch(request)
        }catch{
            print("Error in fetching the data \(error)")
        }
        tableView.reloadData()
    }

}
