//
//  ViewController.swift
//  ToDoList
//
//  Created by Gregor Kramer on 18.12.2020.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(Realm.Configuration.defaultConfiguration.fileURL)
        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title ?? "There are no rows now"
            cell.accessoryType = item.done ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectedItem = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    selectedItem.done = !selectedItem.done
                }
            } catch {
                print(error)
            }
            tableView.reloadData()
        }

    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            do {
                try self.realm.write{
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.createdDate = Date()
                    self.realm.add(newItem)
                }
            } catch {
                print(error)
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        do {
            todoItems = try realm.objects(Item.self)
        } catch {
            print(error)
        }
    }
    
}

