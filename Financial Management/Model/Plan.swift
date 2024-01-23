//
//  Plan.swift
//  Financial Management
//
//  Created by Macmini on 23/01/2024.
//

import Foundation

struct PlanItem: Codable {
    var name: String
    var forWallet: WalletItem
    var amount: Double
    var used: Double
}

class Plan {
    
    static let shared = Plan()
    
    private init() {}
    
    var plans: [PlanItem] {
        get {
            if let data = UserDefaults.standard.value(forKey: "plans") as? Data {
                do {
                    let plans = try PropertyListDecoder().decode([PlanItem].self, from: data)
                    return plans
                } catch {
                    print("Failed to decode plans")
                }
            }
            return []
        }
        set {
            do {
                let data = try PropertyListEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: "plans")
            } catch {
                print("Failed to encode plans")
            }
        }
    }
}
