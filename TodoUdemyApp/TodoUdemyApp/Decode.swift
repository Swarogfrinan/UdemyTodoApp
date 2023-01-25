//
//  Decode.swift
//  TodoUdemyApp
//
//  Created by Ilya Vasilev on 23.01.2023.
//

import Foundation
/* To save Items */
let identifier = "Cell"
let defaults = UserDefaults.standard
let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Items.plist")

//        let encoder = PropertyListEncoder()
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: dataFilePath!)


/* to Load items */
//        if let data = try? Data(contentsOf: dataFilePath!)  {
//            let decoder = PropertyListDecoder()

//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error to decoding item array \(error)")
