//
//  CatagoryTableView.swift
//  ToDoey
//
//  Created by Pankaj Sharma on 7/14/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
//import SwipeCellKit

class CatagoryTableView: UITableViewController {
    
    var catagotyList: Results<Catagory>?
    
    let realm = try! Realm()
    
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadCatagories()
    }
    
    
    
// MARK: - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagotyList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.catagoryCell, for: indexPath)
        if let catagory = catagotyList?[indexPath.row] {
            cell.textLabel?.text = catagory.name
            guard let color = UIColor(hexString: catagory.cellColor) else { fatalError() }
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
       
        
        return cell
    }
    
    // MARK: - TableView delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Keys.goToItemVC, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let catagory = catagotyList?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(catagory)
                    }
                } catch {
                    print("Error deleting row: \(error)")
                }
            }
        }
        tableView.reloadData()
        
    }
    

//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let modifyAction = UIContextualAction(style: .normal, title: "Delete", handler: { (ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
//            success(true)
//        })
//            //modifyAction.image = UIImage(named: "delete-icon")
//        
//            modifyAction.backgroundColor = UIColor.red
//            return UISwipeActionsConfiguration(actions: [modifyAction])
//        }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Keys.goToItemVC {
            let destinationVC = segue.destination as! TodoListViewController
            
           if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = catagotyList?[indexPath.row]
            }
            
            
        }
    }
    
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        addCatagory()
    }
    
    // MARK: - Alert controller method
    
    func addCatagory() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Catagory", message: "", preferredStyle: .alert)
        
        let addButton = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCatagory = Catagory()
            newCatagory.name = textField.text!
            newCatagory.cellColor = UIColor.randomFlat.hexValue()
           // self.catagoryArray.append(newCatagory)
            self.saveCatagories(catagories: newCatagory)
            
        }
        
        alert.addTextField { (alertTextField: UITextField) in
            alertTextField.placeholder = "Add catagory"
            textField = alertTextField
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
       
        alert.addAction(addButton)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    
    }
    
    // MARK: - Save and load data method
    
    func saveCatagories(catagories: Catagory) {
        do {
            try realm.write {
                realm.add(catagories)
            }
        } catch {
            print("Error from Catagory \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCatagories() {
        
        catagotyList = realm.objects(Catagory.self)
        
//        let request: NSFetchRequest<Catagory> = Catagory.fetchRequest()
//
//        do {
//            catagoryArray = try context.fetch(request)
//        } catch {
//            print("Error from catagory error : \(error)")
//        }
        
    }
    

}
