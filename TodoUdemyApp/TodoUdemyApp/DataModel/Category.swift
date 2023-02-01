import Foundation
import RealmSwift

class Category : Object {
@objc dynamic var title : String = ""
@objc dynamic var color : String = ""
let items = List<Item>()
}
