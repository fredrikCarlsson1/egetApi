//
//  Garage.swift
//  PerfectTemplate
//
//  Created by Fredrik Carlsson on 2018-05-22.
//

import PerfectLib
import Foundation

class Garage : JSONConvertibleObject{
    var name: String
    var parkingLots: [ParkingLot]
    var availableParkingLots: Int
    var takenParkingLots: Int
    
    
    init(name: String, parkingLots: Int, availableParkingLots: Int = 0, takenParkingLots: Int = 0) {
        self.name = name
        self.parkingLots = []
        for _ in 0..<parkingLots {
            self.parkingLots.append(ParkingLot(available: true))
        }
        if takenParkingLots > 0 {
            self.availableParkingLots = availableParkingLots
        }
        else{
            self.availableParkingLots = parkingLots
        }
        
        self.takenParkingLots = takenParkingLots
    }
    
    

    

    override public func getJSONValues() -> [String : Any] {
        return [
            "name":name,
            "parkingLots":parkingLots,
            "availableParkingLots": availableParkingLots,
            "takenParkingLots": takenParkingLots

        ]
    }
    
    public func toString() -> String {

        
            return "[name:\(name), parkingLots:\(parkingLots), availableParkingLots:\(availableParkingLots), takenParkingLots:\(takenParkingLots)]"
        
        
    }
    
}







