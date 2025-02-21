//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Shashank B on 21/02/25.
//

import Foundation

struct ExpenseItem:Identifiable,Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}


@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }
}
