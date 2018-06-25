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
    var ItemArray = ["Buy Eggs", "Call AJ", "Mail Check"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func addTodoTaskTapped(_ sender: Any) {
        addTodoTask()
        
        
    }
    func addTodoTask() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        
        
        
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (action) in
            self.ItemArray.append(textField.text!)
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
        cell.textLabel?.text = ItemArray[indexPath.row]
        

        return cell
    }
    
    // MARK: - Table view delegates Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
