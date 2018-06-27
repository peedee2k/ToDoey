//
//  TodoListViewController.swift
//  ToDoey
//
//  Created by Pankaj Sharma on 6/24/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let toDoCell = "ToDoItemCell"
    var ItemArray = [Item]()
    let defaults = UserDefaults.standard
    let todoArrayKey = "toDoListArray"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadData()
        
        }
    
    
    @IBAction func addTodoTaskTapped(_ sender: Any) {
        addTodoTask()
        
        
    }
    func addTodoTask() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
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
        let endoder = PropertyListEncoder()
        do {
            let data = try endoder.encode(self.ItemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error - \(error)")
        }
        self.tableView.reloadData()
    }
    
    // Load data method
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                ItemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error - \(error)")
            }
            
        }
        
        
    }
    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ItemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: toDoCell, for: indexPath)
        let item = ItemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    // MARK: - Table view delegates Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = ItemArray[indexPath.row]
        item.done = !item.done
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    

}
