//
//  ViewController.swift
//  Todoey
//
//  Created by Mikael Elo Ark on 22/09/2018.
//  Copyright © 2018 Mikael Ark. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]() //["Find Mike", "Buy Eggos", "Destory Demogorgon"]
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        print(dataFilePath)
        
        loadItems()

//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //correct
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
   
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title

        cell.accessoryType = item.done ? .checkmark : .none
        
//
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
//
        return cell
    }

    //MARK -TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK ADD new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action =  UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen once the user clicks the "Add Item" button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            //print(alertTextField.text)
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            
            print("Error encoding itemArray, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding array \(error)")
            }
        }
    }
}

