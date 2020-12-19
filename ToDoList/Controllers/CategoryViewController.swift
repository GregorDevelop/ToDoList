//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Gregor Kramer on 19.12.2020.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    var realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
//        print(Realm.Configuration.defaultConfiguration.fileURL)

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "There are no categories"
        return cell
    }
  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            do {
                try self.realm.write{
                    let newCategory = Category()
                    newCategory.name = textField.text!
                    self.realm.add(newCategory)
                }
            } catch {
                print(error)
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadCategories() {
        do {
            categories = try realm.objects(Category.self)
        } catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destionationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destionationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
