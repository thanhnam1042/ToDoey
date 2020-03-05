//
//  ViewController.swift
//  ToDoey
//
//  Created by BSP on 3/5/20.
//  Copyright © 2020 vothanhnam. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let newItem = Item()
//        newItem.title = "Buy macbook"
//        itemArray.append(newItem)
//
//        let newItem1 = Item()
//        newItem1.title = "Buy mac mini"
//        itemArray.append(newItem1)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy mac pro"
//        itemArray.append(newItem2)
        
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
        //            itemArray = items
        //        }
        loadItems()
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //Ternary operator =>
        //value = condition ? valueIfTrue : valueFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        //        if itemArray[indexPath.row].done == true{
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        if itemArray[indexPath.row].done == false{
        //            itemArray[indexPath.row].done = true
        //        }else{
        //            itemArray[indexPath.row].done = false
        //        }
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manupulation Methods
    func saveItems() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding item array, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            do{
                let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

