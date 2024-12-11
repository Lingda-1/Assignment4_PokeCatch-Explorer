//
//  Pokemon.swift
//  Assignment4_PokeCatch-Explorer
//
//  Created by user on 2024-12-10.
//

import Foundation

// Model for individual Pokémon
struct Pokemon: Decodable {
    let name: String
    let url: String
}

// Model for Pokémon list response
struct PokemonListResponse: Decodable {
    let results: [Pokemon]
}
