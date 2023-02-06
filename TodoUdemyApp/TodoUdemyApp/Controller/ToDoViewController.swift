import UIKit
import ChameleonFramework
import RealmSwift

class ToDoViewController: SwipeTableViewController {
    
    // MARK: Constants
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var toDoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        if let colourHex = selectedCategory?.color {
            navigationController?.navigationBar.barTintColor = UIColor(hexString: colourHex)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex = selectedCategory?.color {
            title = selectedCategory!.title
            
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller doesnt not exist")}
            if let navBarColour = UIColor(hexString: colourHex) {
                navBar.backgroundColor = navBarColour
                searchBar.barTintColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
            }
        }
    }
    
    
    //MARK: Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(item)
                }
            } catch {
                print("Error delete items : \(error)")
            }
        }
    }
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    // MARK: Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) {_ in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dataCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error save realm \(error) ")
                }
                
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            print("User create new item \(String(describing: alertTextField.text))")
            textField = alertTextField
        }
        
        self.present(alert, animated: true)
    }
}

// MARK: DataSource

extension ToDoViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCategory?.items.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.backgroundColor = UIColor.randomFlat()
        
        if  let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let colour =  UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
                cell.accessoryType = item.done ? .checkmark : .none
            } else {
                cell.textLabel?.text = "No item added yet"
        }
        return cell
    }
}
    

// MARK: TableView Delegate Methods

extension ToDoViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write({
                    item.done = !item.done
                })
            } catch {
                print("Eror saving done status : \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}
    
    extension ToDoViewController: UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
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

