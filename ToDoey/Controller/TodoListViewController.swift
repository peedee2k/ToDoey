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
    override func viewDidLoad() {
        super.viewDidLoad()
        createItems()
        if let items = defaults.array(forKey: todoArrayKey) as? [Item] {
            ItemArray = items
        }
        
        }
    
    func createItems() {
        let item1 = Item()
        item1.title = "Find Mike"
        ItemArray.append(item1)
        let item2 = Item()
        item2.title = "buy Milk"
        ItemArray.append(item2)
        let item3 = Item()
        item3.title = "Call Jack"
        ItemArray.append(item3)
        let item4 = Item()
        item4.title = "Pay bill"
        ItemArray.append(item4)
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
            self.defaults.set(self.ItemArray, forKey: self.todoArrayKey)
            self.tableView.reloadData()
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
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    

}
