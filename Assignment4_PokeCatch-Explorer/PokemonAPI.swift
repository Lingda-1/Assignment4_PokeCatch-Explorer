//
//  PokemonAPI.swift
//  Assignment4_PokeCatch-Explorer
//
//  Created by user on 2024-12-10.
//

import Foundation

class PokemonAPI {
    static let shared = PokemonAPI() // Singleton instance
    private let baseURL = "https://pokeapi.co/api/v2/"

    // Fetch Pokémon list from API
    func fetchPokemonList(completion: @escaping ([Pokemon]?) -> Void) {
        guard let url = URL(string: "\(baseURL)pokemon?limit=300") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors or no data
            if let error = error {
                print("Error fetching Pokémon list: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            // Decode the JSON response
            do {
                let decodedResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                completion(decodedResponse.results)
            } catch {
                print("Error decoding Pokémon list: \(error)")
                completion(nil)
            }
        }.resume()
    }

    // Fetch Pokémon details (image URL)
    func fetchPokemonDetails(for pokemonName: String, completion: @escaping (String?, String?) -> Void) {
        guard let url = URL(string: "\(baseURL)pokemon/\(pokemonName.lowercased())") else {
            completion(nil, nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors or no data
            if let error = error {
                print("Error fetching Pokémon details: \(error)")
                completion(nil, nil)
                return
            }
            guard let data = data else {
                completion(nil, nil)
                return
            }

            // Decode the JSON response
            do {
                let decodedResponse = try JSONDecoder().decode(PokemonDetailResponse.self, from: data)
                let imageURL = decodedResponse.sprites.front_default
                completion(nil, imageURL) // Return image URL
            } catch {
                print("Error decoding Pokémon details: \(error)")
                completion(nil, nil)
            }
        }.resume()
    }

    // Fetch Pokémon species details for description
    func fetchPokemonSpecies(for pokemonName: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(baseURL)pokemon-species/\(pokemonName.lowercased())/") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors or no data
            if let error = error {
                print("Error fetching Pokémon species: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }

            // Parse JSON response for description
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let flavorTextEntries = json?["flavor_text_entries"] as? [[String: Any]] {
                    if let englishEntry = flavorTextEntries.first(where: {
                        ($0["language"] as? [String: Any])?["name"] as? String == "en"
                    }) {
                        completion(englishEntry["flavor_text"] as? String) // Return description
                        return
                    }
                }
                completion(nil)
            } catch {
                print("Error parsing Pokémon species details: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
