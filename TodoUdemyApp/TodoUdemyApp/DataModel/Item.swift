import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dataCreated : Date?
    @objc dynamic var color : String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
