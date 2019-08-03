import UIKit

enum VendingMachineError: Error {
    case invalidSelection
    case outOfStock
    case insufficientFunds(coinsNeeded: Int)
    
    case noPermission
}

class VendingMachine {
    
    //MARK: 속성
    
    private(set) var inventory = Inventory()
    private(set) var coinsDeposited: Coin = 0
    private(set) var purchasedItems = Inventory()
    
    //MARK: 메소드
    
    func insertCoins(_ amount: Coin) {
        coinsDeposited += amount
    }
    
    func deductCoins(_ amount: Coin) throws {
        guard amount <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: amount - coinsDeposited)
        }
        coinsDeposited -= amount
    }
    
    func takeItem(named name: String) throws -> Date {
        return try inventory[name].removeBeverage()
    }
    
    func vend(itemNamed name: String) throws -> Beverage {
        
        let beverage = inventory[name]
        try deductCoins(beverage.price)
        
        let manufactureDate = try takeItem(named: beverage.name)
        purchasedItems.addBeverage(beverage, manufactureDate: manufactureDate)
        
        return beverage
    }
    
    func addBeverageType(_ beverage: Beverage) {
        inventory.addBeverageType(beverage)
    }
    
    func addBeverage(_ beverage: Beverage, manufactureDate: Date = Date()) {
        inventory.addBeverage(beverage, manufactureDate: manufactureDate)
    }
    
    func addBeverages(_ beverage: Beverage, manufactureDates: [Date]) {
        manufactureDates.forEach { addBeverage(beverage, manufactureDate: $0) }
    }
    
    //MARK: 연산 프로퍼티
    
    var purchasableItems: [Beverage] {
        return inventory.allBeverages.filter { $0.price <= coinsDeposited }
    }
}
