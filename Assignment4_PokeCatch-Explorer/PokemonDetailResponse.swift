//
//  PokemonDetailResponse.swift
//  Assignment4_PokeCatch-Explorer
//
//  Created by user on 2024-12-10.
//

import Foundation

struct PokemonDetailResponse: Codable {
    let sprites: Sprites

    struct Sprites: Codable {
        let front_default: String
    }
}
