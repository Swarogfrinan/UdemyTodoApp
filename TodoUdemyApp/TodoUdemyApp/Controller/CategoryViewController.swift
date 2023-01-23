import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let identifier = "CategoryTableCell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: Data manipulation method
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error encoding item array \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading request in DataBase")
        }
        tableView.reloadData()
    }
    //MARK: Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) {_ in
            print("Sucsess add item \(String(describing: textField.text))")
            
            let newCategory = Category(context: self.context)
            newCategory.title = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
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
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.title
        return cell
    }
}

//MARK: TableView Delegate Methods

extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tappped a cell \(categoryArray[indexPath.row]) by number : \(indexPath.row)")
        performSegue(withIdentifier: "goToItems", sender: self)
        saveCategories()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(categoryArray[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveCategories()
        }
    }
}


