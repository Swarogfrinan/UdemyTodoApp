import UIKit
import Foundation

class ToDoViewController: UITableViewController {
    
    // MARK: Constants
    let identifier = "Cell"
    let itemArray = ["First Item","Second Item", "Third Item"]
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) {_ in
            print("Sucsess add item \(String(describing: textField.text))")
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
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
}
// MARK: Extension Delegate Method
extension ToDoViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        print("you tappped a cell \(itemArray[indexPath.row]) by number \(indexPath.row)")
       
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  
}
