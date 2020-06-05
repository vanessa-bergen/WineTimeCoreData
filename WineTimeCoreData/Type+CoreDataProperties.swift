//
//  Type+CoreDataProperties.swift
//  WineTimeCoreData
//
//  Created by Vanessa Bergen on 2020-06-02.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//
//

import Foundation
import CoreData


extension Type {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Type> {
        return NSFetchRequest<Type>(entityName: "Type")
    }

    @NSManaged public var typeName: String?
    @NSManaged public var wine: NSSet?
    
    public var wrappedType: String {
        typeName ?? "Red"
    }
    
    public var wineArray: [Wine] {
        // convert from NSSet to Set<Wine>
        let set = wine as? Set<Wine> ?? []
        
        // converting to a sorted array
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for wine
extension Type {

    @objc(addWineObject:)
    @NSManaged public func addToWine(_ value: Wine)

    @objc(removeWineObject:)
    @NSManaged public func removeFromWine(_ value: Wine)

    @objc(addWine:)
    @NSManaged public func addToWine(_ values: NSSet)

    @objc(removeWine:)
    @NSManaged public func removeFromWine(_ values: NSSet)

}
