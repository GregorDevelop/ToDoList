//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Gregor Kramer on 19.12.2020.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeViewController {

    var realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
//        print(Realm.Configuration.defaultConfiguration.fileURL)

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor.systemBlue
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navBar = navigationController?.navigationBar else {fatalError()}
        navBar.backgroundColor = UIColor(hexString: "2F8AFE")
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(UIColor(hexString: "2F8AFE")!, returnFlat: true)]


    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "There are no categories"
        if let color = UIColor(hexString: categories?[indexPath.row].color ?? "No color") {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)    
        }
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
                    newCategory.color = UIColor.randomFlat().hexValue()
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print(error)
            }
        }
    }
    
}
