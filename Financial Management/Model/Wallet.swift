//
//  Wallet.swift
//  Financial Management
//
//  Created by Mac on 15/12/2023.
//

import Foundation

struct WalletItem: Codable {
    var name: String
    var icon: String
    var amount: Double
    var used: Double
}

class Wallet {
    
    static let shared = Wallet()
    
    private init() {}
    
    var wallets: [WalletItem] {
        get {
            if let data = UserDefaults.standard.value(forKey: "wallets") as? Data {
                do {
                    let expenses = try PropertyListDecoder().decode([WalletItem].self, from: data)
                    return expenses
                } catch {
                    print("Failed to decode wallets")
                }
            }
            return []
        }
        set {
            do {
                let data = try PropertyListEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: "wallets")
            } catch {
                print("Failed to encode wallets")
            }
        }
    }
}
