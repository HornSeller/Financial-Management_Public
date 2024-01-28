//
//  Transaction.swift
//  Financial Management
//
//  Created by Mac on 14/12/2023.
//

import Foundation

enum TransactionType: String, Codable {
    case income
    case expense
}

struct TransactionItem: Codable {
    var title: String
    var id: Int
    var inWallet: String
    var forPlan: String
    var amount: Double
    var date: Date
    var type: TransactionType
}

class Transaction {
    var transactions: [TransactionItem] {
        get {
            if let data = UserDefaults.standard.value(forKey: "transactions") as? Data {
                do {
                    let transactions = try PropertyListDecoder().decode([TransactionItem].self, from: data)
                    return transactions
                } catch {
                    print("Failed to decode transactions")
                }
            }
            return []
        }
        set {
            do {
                let data = try PropertyListEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: "transactions")
            } catch {
                print("Failed to encode transactions")
            }
        }
    }
    
    // Tạo một shared instance để sử dụng trong toàn bộ ứng dụng
    static let shared = Transaction()
    
    private init() {}
}
