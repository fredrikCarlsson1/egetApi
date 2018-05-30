//
//  AllGarages.swift
//  PerfectTemplate
//
//  Created by Fredrik Carlsson on 2018-05-22.
//

import Foundation
import PerfectHTTP


class AllGarages {
    var data = [Garage]()
    
    init () {
        if getFileToJsonGarage().count != 0 {
            for garage in getFileToJsonGarage(){
                data.append(garage)
            }
        }
        
    }
    
    public func list() -> String {
        return toString()
    }
    
    //GEt one garage
    public func getGarage(_ jsonString: String) -> String? {
        var garaget: Garage?
        for garage in data{
            if jsonString == garage.name {
                garaget = garage
            }
        }
        
        do {
            return try? garaget.jsonEncodedString()
        } catch {
            print(error)
        }
    }
    
    
    //GEt one Car
    public func getCar(garageName: String, carName: String) -> String? {
        var garaget: Garage?
        var currentCar: Car?
        for garage in data{
            if garageName == garage.name {
                garaget = garage
                break
            }
        }
        if let currentGarage = garaget {
            for parkinglot in currentGarage.parkingLots{
                print(parkinglot.car?.regNumber)
                if carName == parkinglot.car?.regNumber{
                    currentCar = parkinglot.car
                }
            }
        }
            
        else {
            return "Cant find that garage"
        }
        
        do {
            if let car = currentCar {
                return try? car.jsonEncodedString()
            }
            else {
                return "No car with that reg-nr"
            }
        }
    }
    
    
    // ADD ONE GARAGE
    public func add(_ jsonString: String) -> String? {
        do {
            var name = ""
            var size = 0
            
            if let data = jsonString.data(using: .utf8) {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return nil}
                if let newName = json["name"] as? String {
                    name = newName
                }
                if let newSize = json["size"] as? Int {
                    size = newSize
                }
            }
            let new = Garage(name: name, parkingLots: size)
            self.data.append(new)
            
        }
        catch {
            return "Error1"
        }
        writeToDocument(text: toString())
        
        
        return toString()
    }
    
    //ADD ONE CAR
    public func postCarInGarage(endPoint: String, jsonString: String) -> String? {
        var currentGarage: Garage?
        for garage in data {
            if garage.name == endPoint{
                currentGarage = garage
            }
        }
        
        if let garage = currentGarage {
            do {
                var regNR = ""
                var color = ""
                var valueInSwedishCrowns = 0.0
                var model = ""
                
                if let data = jsonString.data(using: .utf8) {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return nil}
                    if let newReg = json["regNr"] as? String {
                        regNR = newReg
                    }
                    if let newModel = json["model"] as? String {
                        model = newModel
                    }
                    if let newColor = json["color"] as? String {
                        color = newColor
                    }
                    if let newValue = json["valueInSwedishMoney"] as? Double {
                        valueInSwedishCrowns = newValue
                    }
                }
                
                for parkingLot in garage.parkingLots {
                    if parkingLot.available {
                        let newCar = Car(regNumber: regNR, model: model, valueInSweMoney: valueInSwedishCrowns, color: color)
                        parkingLot.car = newCar
                        parkingLot.available = false
                        garage.availableParkingLots -= 1
                        garage.takenParkingLots += 1
                        do {
                            for (index,garage) in data.enumerated() {
                                if garage.name == endPoint{
                                    self.data[index] = garage
                                    print(index)
                                }
                            }
                            writeToDocument(text: toString())
                            return try? garage.jsonEncodedString()
                            
                        }
                        catch {
                            print(error)
                        }
                    }
                }
            }
            catch {
                return "Error"
            }
            writeToDocument(text: toString())
            
            return ""
            
        }
        else {
            return "That garage does not exist"
        }
        
        
    }
    
    
    //delete one garage
    public func delete(_ garageName: String)-> String? {
        
        for (index, garage) in data.enumerated() {
            if garage.name == garageName {
                print(index)
                data.remove(at: index)
                break
            }
        }
        
        writeToDocument(text: toString())
        return toString()
    }
    
    
    //delete one car
    public func delete(garageName: String, carName: String)-> String? {
        var garageIndex: Int?
        for (index, garage) in data.enumerated() {
            if garage.name == garageName {
                garageIndex = index

                break
            }
        }
        if let index = garageIndex {
            for (parkIndex, parkingLot) in data[index].parkingLots.enumerated(){
                if carName == parkingLot.car?.regNumber {
                    self.data[index].parkingLots[parkIndex].car = nil
                    self.data[index].parkingLots[parkIndex].available = true
                    self.data[index].availableParkingLots += 1
                    self.data[index].takenParkingLots -= 1
                    writeToDocument(text: toString())
                    break
                }
            }
        }
 
        return toString()
    }
    
    
    
    
    
    //Uppdaterar dokumentet
    func writeToDocument(text: String) {
        let filename = "test"
        let documentDirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirUrl.appendingPathComponent(filename).appendingPathExtension("txt")
        
        let writeString = text
        
        do {
            try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    
    //Gör om string dokument till json så att det går att läsa av det
    func getFileToJsonGarage() -> [Garage]{
        let filename = "test"
        let documentDirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirUrl.appendingPathComponent(filename).appendingPathExtension("txt")
        
        var garages = [Garage]()
        
        var readString = ""
        do {
            readString = try String(contentsOf: fileURL)
            
            let dict = readString.toJSON()
            
            for di in (dict as! NSArray) {
                
                let garage = di as! [String: Any]
                if let name = garage["name"] as? String,
                    let parkingLots = garage["parkingLots"] as? NSArray,
                    let availableParkingLots = garage["availableParkingLots"] as? Int,
                    let takenParkingLots = garage["takenParkingLots"] as? Int
                {
                    
                    var newGarage = Garage(name: name, parkingLots: parkingLots.count, availableParkingLots: availableParkingLots, takenParkingLots: takenParkingLots)

                    var currentParkingLots = [ParkingLot]()

                    for lots in parkingLots  {
                        var park = ParkingLot(available: false)
                        let currentParkingLot = lots as! [String: Any]
                        if let available = currentParkingLot["available"] as? Bool{
                            park.available = available

                        if let car = currentParkingLot["car"] as? [String: Any]{
                            if let regNr = car["regNr"] as? String{
                                park.car = Car(regNumber: regNr)
                                print(regNr)
                            }
                            if let color = car["color"] as? String {
                                park.car?.color = color
                            }
                            if let valueInSwedishMoney = car["valueInSwedishMoney"] as? Double {
                                park.car?.valueInSwedishMoney = valueInSwedishMoney
                            }
                            if let model = car["model"] as? String {
                                park.car?.model = model
                            }

                        }

                        currentParkingLots.append(park)
                        newGarage.parkingLots = currentParkingLots
                   }
                   }
                    garages.append(newGarage)
                }
            }
        }
            
        catch let error as NSError {
            print (error)
        }
        
        return garages
    }
    
    // Convenient encoding method that returns a string from JSON objects.
    public func toString() -> String {
        var out = [String]()
        
        for m in self.data {
            do {
                out.append(try m.jsonEncodedString())
            } catch {
                print(error)
            }
        }
        return "[\(out.joined(separator: ","))]"
    }
    
    
}

//En extension för att göra om string till json. används i getFileToJson
extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) 
    }
}








