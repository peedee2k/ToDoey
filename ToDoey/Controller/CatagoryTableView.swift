//
//  CatagoryTableView.swift
//  ToDoey
//
//  Created by Pankaj Sharma on 7/14/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit
import CoreData

class CatagoryTableView: UITableViewController {
    
    var catagoryArray = [Catagory]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        loadCatagories()
    }
    
    
    
// MARK: - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.catagoryCell, for: indexPath)
        cell.textLabel?.text = catagoryArray[indexPath.row].catagoryItem
        
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
                destinationVC.selectedCategory = catagoryArray[indexPath.row]
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
            let newCatagory = Catagory(context: self.context)
            newCatagory.catagoryItem = textField.text!
            self.catagoryArray.append(newCatagory)
            self.saveCatagories()
            
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
    
    func saveCatagories() {
        do {
            try context.save()
        } catch {
            print("Error from Catagory \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCatagories() {
        
        let request: NSFetchRequest<Catagory> = Catagory.fetchRequest()
        
        do {
            catagoryArray = try context.fetch(request)
        } catch {
            print("Error from catagory error : \(error)")
        }
        
    }
    

}
