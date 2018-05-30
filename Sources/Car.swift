//
//  File.swift
//  PerfectTemplate
//
//  Created by Fredrik Carlsson on 2018-05-22.
//

import Foundation
import PerfectLib

class Car: JSONConvertibleObject {
    var regNumber: String
    var model: String
    var valueInSwedishMoney: Double
    var color: String
    
    init (regNumber: String, model: String = "", valueInSweMoney: Double = 0.0 , color: String = "") {
        self.regNumber = regNumber
        self.model = model
        self.valueInSwedishMoney = valueInSweMoney
        self.color = color
    }
    
    override public func getJSONValues() -> [String : Any] {
        return [
            "regNr":regNumber,
            "model":model,
            "valueInSwedishMoney":valueInSwedishMoney,
            "color":color
        ]
    }
    
    
    func toString()-> String {
        return "\(regNumber)"
    }
    
    
    
}
