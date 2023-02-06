import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

final class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories : Results<Category>?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller doesnt not exist")}
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    //MARK: Data manipulation method
    
    func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error save data to Realm \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: Delete data from swipe
     override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error delete items : \(error)")
            }
        }
    }
    
    //MARK: Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) {_ in
            print("Sucsess add item \(String(describing: textField.text))")
            
            let newCategory = Category()
            newCategory.title = textField.text!
            let newColor = UIColor.randomFlat().hexValue()
            newCategory.color = newColor
            self.save(category: newCategory)
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            print("User create new category \(String(describing: alertTextField.text))")
            textField = alertTextField
        }
        
        
        present(alert, animated: true)
    }
}

//MARK: - TableView DataSource Methods

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.title
            
            guard let categoryColour = UIColor(hexString: category.color)  else {fatalError("Doesnt categories color exist")}
            
                cell.backgroundColor = categoryColour
                cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
    
       
        
       
        
        return cell
    }
}

//MARK: - TableView Delegate Methods

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let didSelectCategory = categories?[indexPath.row] {
            print("you tappped a cell \(didSelectCategory) by number : \(indexPath.row)")
            performSegue(withIdentifier: "goToItems", sender: self)
            save(category: didSelectCategory)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
        }


