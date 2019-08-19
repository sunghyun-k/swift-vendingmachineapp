import UIKit

class SoftDrink: BeverageWithPhoto {
    var calorie: Int
    
    private enum CodingKeys: CodingKey {
        case calorie
    }
    
    init(name: String, price: Coin, photo: UIImage?, brand: String, packageSize: Int, calorie: Int) {
        self.calorie = calorie
        super.init(name: name, price: price, photo: photo, brand: brand, packageSize: packageSize, beverageTemperature: 10, expirationPeriod: Date.timeInterval(fromDays: 365))
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        calorie = try container.decode(Int.self, forKey: .calorie)
        try super.init(from: decoder)
    }
    
    var isLowCalorie: Bool {
        return calorie < 80
    }
}
