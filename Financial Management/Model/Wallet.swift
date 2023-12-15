//
//  Wallet.swift
//  Financial Management
//
//  Created by Mac on 15/12/2023.
//

import Foundation

struct ExpenseItem: Codable {
    var name: String
    var icon: String
    var amount: Double
}

class Wallet {
    
    static let shared = Wallet()
    
    private init() {}
    
    var expenses: [ExpenseItem] {
        get {
            if let data = UserDefaults.standard.value(forKey: "expenses") as? Data {
                do {
                    let expenses = try PropertyListDecoder().decode([ExpenseItem].self, from: data)
                    return expenses
                } catch {
                    print("Failed to decode expenses")
                }
            }
            return []
        }
        set {
            do {
                let data = try PropertyListEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: "expenses")
            } catch {
                print("Failed to encode expenses")
            }
        }
    }
}
