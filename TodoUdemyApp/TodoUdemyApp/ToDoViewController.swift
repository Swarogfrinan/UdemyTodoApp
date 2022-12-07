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
        tableView.deselectRow(at: indexPath animated: true)
    }
}
