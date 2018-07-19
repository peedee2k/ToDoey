//
//  CatagoryTableView.swift
//  ToDoey
//
//  Created by Pankaj Sharma on 7/14/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import RealmSwift

class CatagoryTableView: UITableViewController {
    
    var catagotyList: Results<Catagory>?
    
    let realm = try! Realm()
    
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        loadCatagories()
    }
    
    
    
// MARK: - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagotyList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.catagoryCell, for: indexPath)
        cell.textLabel?.text = catagotyList?[indexPath.row].name ?? "No Catagories Added"
        
        return cell
    }
    
    // MARK: - TableView delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Keys.goToItemVC, sender: self)
    }
    
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
