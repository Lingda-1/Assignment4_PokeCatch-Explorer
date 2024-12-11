//
//  CoreDataManager.swift
//  Assignment4_PokeCatch-Explorer
//
//  Created by user on 2024-12-10.
//

import Foundation
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager() // Singleton instance for centralized access

    // Persistent container for Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Assignment4_PokeCatch_Explorer") // Replace with your .xcdatamodeld name
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // Managed object context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Add Caught Pokémon
    func addCaughtPokemon(name: String, imageURL: String, timestamp: Date = Date()) {
        let caughtPokemon = CaughtPokemon(context: context) // Create a new CaughtPokemon object
        caughtPokemon.name = name
        caughtPokemon.imageURL = imageURL
        caughtPokemon.timestamp = timestamp
        saveContext() // Save changes to Core Data
    }

    // MARK: - Fetch All Caught Pokémon
    func fetchCaughtPokemons() -> [CaughtPokemon] {
        let fetchRequest: NSFetchRequest<CaughtPokemon> = CaughtPokemon.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching caught Pokémon: \(error)")
            return []
        }
    }

    // MARK: - Delete a Caught Pokémon
    func deleteCaughtPokemon(_ pokemon: CaughtPokemon) {
        context.delete(pokemon)
        saveContext() // Save changes to Core Data
    }

    // MARK: - Delete All Caught Pokémon
    func deleteAllCaughtPokemons() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CaughtPokemon.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
            print("All caught Pokémon have been deleted.")
        } catch {
            print("Error deleting all caught Pokémon: \(error)")
        }
    }

    // MARK: - Check if Pokémon is Already Caught
    func isPokemonCaught(name: String) -> Bool {
        let fetchRequest: NSFetchRequest<CaughtPokemon> = CaughtPokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0 // Returns true if Pokémon already exists
        } catch {
            print("Error checking if Pokémon is already caught: \(error)")
            return false
        }
    }

    // MARK: - Save Context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
