//
//  TodoListViewController.swift
//  ToDoey
//
//  Created by Pankaj Sharma on 6/24/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: UITableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var toDoItems: Results<Item>?
    
    var selectedCategory: Catagory? {
        didSet {
            loadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath)
        tableView.separatorStyle = .none
        loadData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let hexColor = selectedCategory?.cellColor  else { fatalError() }
        title = selectedCategory!.name
       updateNavBar(withHexCode: hexColor)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK:- NavBar Setup Method
    
    func updateNavBar(withHexCode colorHexCode: String) {
       
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist")}
        guard let barColor = UIColor(hexString: colorHexCode) else  { fatalError() }
        navBar.barTintColor = barColor
        searchBar.barTintColor = barColor
        navBar.tintColor = ContrastColorOf(barColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(barColor, returnFlat: true)]
    }
    
    
    
    @IBAction func addTodoTaskTapped(_ sender: Any) {
        addTodoTask()
        
    }
    // MARK: - Add new Todo list
    
    func addTodoTask() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            if  let currentCatagory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        currentCatagory.items.append(newItem)
                    }
                } catch {
                    print("Error while saving \(error)")
                }
                
            }
            
            //            let newItem = Item()
            //            newItem.title = textField.text!
            //            newItem.done = false
            //            newItem.parentCatagory = self.selectedCategory
            
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
    
    // MARK: - Save data Methods
    
    // Load data method
    
    func loadData() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.itemCell, for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            let cellColor = UIColor(hexString: (selectedCategory?.cellColor)!)
            
            if let color = cellColor?.darken(byPercentage:
                CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
    }
    
    // MARK: - Table view delegates Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    // to delete object
                    // realm.delete(item)
                    // I would prefere to do this on tableview delegate method did commit
                    item.done = !item.done
                }
            } catch {
                print("Error saving done button \(error)")
            }
            tableView.reloadData()
        }
        
        
        //        let item = toDoItems![indexPath.row]
        //        context.delete(item)
        //        ItemArray.remove(at: indexPath.row)
        //        item.done = !item.done
        //        saveItem()
        //        tableView.deselectRow(at: indexPath, animated: true)
        //        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let item = toDoItems?[indexPath.row] else { return }
            do {
                try realm.write {
                     realm.delete(item)
            
                }
            } catch {
                print("Error while deleting row: \(error)")
            }
            tableView.reloadData()
        }
    }
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let modifyAction = UIContextualAction(style: .normal, title: "Delete", handler: { (ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
//            success(true)
//        })
//        //modifyAction.image = UIImage(named: "delete-icon")
//        
//        modifyAction.backgroundColor = UIColor.red
//        return UISwipeActionsConfiguration(actions: [modifyAction])
//    }
    
    
}

extension TodoListViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
            
            tableView.reloadData()
    //        let request: NSFetchRequest<Item> = Item.fetchRequest()
    //
    //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    //
    //
    //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    //
    //        loadData(With: request, predicate: predicate)
    //
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

