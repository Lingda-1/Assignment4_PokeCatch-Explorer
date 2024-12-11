//
//  CaughtPokemon+CoreDataProperties.swift
//  Assignment4_PokeCatch-Explorer
//
//  Created by user on 2024-12-10.
//
//

import Foundation
import CoreData


extension CaughtPokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CaughtPokemon> {
        return NSFetchRequest<CaughtPokemon>(entityName: "CaughtPokemon")
    }

    @NSManaged public var name: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var timestamp: Date?

}

extension CaughtPokemon : Identifiable {

}
