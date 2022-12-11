import UIKit
import Foundation

class ToDoViewController: UITableViewController {
    
    // MARK: Constants
    
    let identifier = "Cell"
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Items.plist")
    
    
    var itemArray = [Item]()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "itemArray") as? [Item] {
            itemArray = items
        }
    }
    
    // MARK: Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) {_ in
            print("Sucsess add item \(String(describing: textField.text))")
            
            let newItem = Item()
            newItem.title = textField.text!
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
         let encoder = PropertyListEncoder()
         do {
             let data = try encoder.encode(self.itemArray)
             try data.write(to: dataFilePath!)
         } catch {
             print("Error encoding item array \(error)")
         }
         tableView.reloadData()
     }
    }


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
        tableView.reloadData()
        
       
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  
}
