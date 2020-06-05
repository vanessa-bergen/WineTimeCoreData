//
//  Wine+CoreDataProperties.swift
//  WineTimeCoreData
//
//  Created by Vanessa Bergen on 2020-06-04.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//
//

import Foundation
import CoreData


extension Wine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wine> {
        return NSFetchRequest<Wine>(entityName: "Wine")
    }

    @NSManaged public var comments: String?
    @NSManaged public var country: Int16
    @NSManaged public var grape: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var price: Int16
    @NSManaged public var hasRegion: Bool
    @NSManaged public var region: String?
    @NSManaged public var type: Type?
    
    public var wrappedName: String {
        name ?? ""
    }
    
    public var wrappedGrape: String {
        grape ?? ""
    }
    
    public var wrappedComments: String {
        comments ?? ""
    }
    
    public var wrappedRegion: String {
        region ?? ""
    }
    
    static let countries = ["Australia", "Argentina", "Canada", "Chile", "Italy", "France", "Germany", "Greece", "New Zealand", "Portugal", "Spain", "South Africa", "USA", "Other"]
    
    var countryName: String {
        Wine.countries[Int(country)]
    }
    
    enum WineType: String, CaseIterable {
        case red, white, rose, specialty
    }

}
