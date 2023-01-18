import UIKit
import CoreData

class ToDoViewController: UITableViewController {
    
    // MARK: Constants
    
    let identifier = "Cell"
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    
    // MARK: Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
    
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) {_ in
            print("Sucsess add item \(String(describing: textField.text))")
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.checked = false
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            print("User create new item \(String(describing: alertTextField.text))")
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

//MARK: Private methods

private extension ToDoViewController {
    
    func saveItems() {
        do {
           try context.save()
        } catch {
            print("Error encoding item array \(error)")
        }
        tableView.reloadData()
    }
    //        let encoder = PropertyListEncoder()
    //            let data = try encoder.encode(self.itemArray)
    //            try data.write(to: dataFilePath!)
    
    func loadItems() {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("Error loading request in DataBase")
        }
        tableView.reloadData()
    }
}
//        if let data = try? Data(contentsOf: dataFilePath!)  {
//            let decoder = PropertyListDecoder()

//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error to decoding item array \(error)")


// MARK: DataSource

extension ToDoViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.checked ? .checkmark : .none
        cell.textLabel?.text = item.title
        return cell
    }
}

// MARK: Delegate
extension ToDoViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tappped a cell \(itemArray[indexPath.row]) by number \(indexPath.row)")
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveItems()
        }
    }
}

extension ToDoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINTS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("Error loading request in DataBase")
        }
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    }

