import UIKit
import Foundation

class ToDoViewController: UITableViewController {
    
    // MARK: Constants
    let identifier = "Cell"
    let defaults = UserDefaults.standard
    
    var itemArray = [
        Item(name: "First Item", checked: false),
    Item(name: "Second Item", checked: false),
        Item(name: "Third Item", checked: false)
    ]
    
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
            self.itemArray.append(Item(name: textField.text!, checked: false))
            self.defaults.set(self.itemArray, forKey: "itemArray")
            self.tableView.reloadData()
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

// MARK: Extension DataSource Method

extension ToDoViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.checked ? .checkmark : .none
           
        cell.textLabel?.text = item.name
        return cell
    }
}

// MARK: Extension Delegate Method
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
