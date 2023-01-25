import Foundation
import RealmSwift

class Category : Object {
@objc dynamic var title : String = ""
let items = List<Item>()
    let array = Array<Int>()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
