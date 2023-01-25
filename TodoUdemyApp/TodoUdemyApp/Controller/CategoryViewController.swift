import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    let realm = try! Realm()
    let identifier = "CategoryTableCell"
    var categoryArray : Results<Category>?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
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
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) {_ in
            print("Sucsess add item \(String(describing: textField.text))")
            
            let newCategory = Category()
            newCategory.title = textField.text!
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            print("User create new category \(String(describing: alertTextField.text))")
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

//MARK: TableView DataSource Methods

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].title ?? "No categories added yet"
        return cell
    }
}

//MARK: TableView Delegate Methods

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let didSelectCategory = categoryArray?[indexPath.row]{
            print("you tappped a cell \(didSelectCategory) by number : \(indexPath.row)")
            performSegue(withIdentifier: "goToItems", sender: self)
            save(category: didSelectCategory)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let deletedCategory = categoryArray?[indexPath.row] {
            if editingStyle == .delete {
                realm.delete(deletedCategory)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                save(category: deletedCategory)
            }
        }
       
    }
}


