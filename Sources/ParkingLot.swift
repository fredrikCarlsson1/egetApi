//
//  ParkingLot.swift
//  PerfectTemplate
//
//  Created by Fredrik Carlsson on 2018-05-22.
//

import Foundation
import PerfectLib

class ParkingLot: JSONConvertibleObject {
    var available: Bool
    var car: Car?
    
    init(available: Bool = true) {
        self.available = available
    }
    
    override public func getJSONValues() -> [String : Any] {
        return [
            "available":available,
            "car":car
        ]
    }
    
    public func toString() -> String {
        
        let string = "\(self.available), \(self.car?.toString() ?? "")"
        return try! string.jsonEncodedString()
        
    }
}
