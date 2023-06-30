//
//  Pokemon.swift
//  Pokdedex
//
//  Created by Kimia Yazdani on 6/29/23.
//

import Foundation


class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
     
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(_name: String!, _pokedexId: Int!) {
        self._name = _name
        self._pokedexId = _pokedexId
    }
}
