//
//  TodoListViewController.swift
//  ToDoey
//
//  Created by Pankaj Sharma on 6/24/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
        var ItemArray = [Item]()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Catagory? {
        didSet {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
       
        loadData()
        
        }
    
    
    @IBAction func addTodoTaskTapped(_ sender: Any) {
        addTodoTask()
        
    }
    // MARK: - Add new Todo list
    
    func addTodoTask() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (action) in
           
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCatagory = self.selectedCategory
            self.ItemArray.append(newItem)
            self.saveItem()
            
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField: UITextField) in
            alertTextField.placeholder = "Add new todo item here"
            textField = alertTextField
        }
        alert.addAction(addItemAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Save data Methods
    
    
    // Save Items on a plist method
    func saveItem() {
        
        do {
           try context.save()
        } catch {
            print("Error saving message \(error)")
        }
        self.tableView.reloadData()
    }
    
    // Load data method
    
    func loadData(With request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let catagorypredicate = NSPredicate(format: "parentCatagory.catagoryItem MATCHES %@", (selectedCategory?.catagoryItem)!)
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catagorypredicate, addtionalPredicate])
        } else {
            request.predicate = catagorypredicate
        }
        
        
          do {
                ItemArray = try context.fetch(request)
            } catch {
                print("Error while fatching data \(error)")
            }
            tableView.reloadData()
        }
    
    
    
    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ItemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.itemCell, for: indexPath)
        let item = ItemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    // MARK: - Table view delegates Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = ItemArray[indexPath.row]
//        context.delete(item)
//        ItemArray.remove(at: indexPath.row)
        item.done = !item.done
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    

}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(With: request, predicate: predicate)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                
            }
            
            
        }
    }
    
}

