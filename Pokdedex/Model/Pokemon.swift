//
//  Pokemon.swift
//  Pokdedex
//
//  Created by Kimia Yazdani on 6/29/23.
//

import Foundation
import Alamofire


class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvoName: String!
    private var _nextEvoId: String!
    private var _nextEvoSprite: String!
    
    private var _pokemonURL: String!
    
     
    var name: String {
        return _name.capitalized
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = "No Known Evolutions"
        }
        return _nextEvolutionTxt
    }
    
    var height: String {
        if _height == nil {
            _height = "-"
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = "-"
        }
        return _weight
    }
    
    var attack: String {
        // I am using normal ability instead of this.
        if _attack == nil {
            _attack = "-"
        }
        return _attack
    }
    
    var type: String {
        if _type == nil {
            _type = "-"
        }
        return _type
    }
    
    var description: String {
        if _description == nil {
            _description = "We Don't Know Anything About It."
        }
        return _description
    }
    
    var defense: String {
        // I am using hidden ability instead of this.
        if _defense == nil {
            _defense = "-"
        }
        return _defense
    }
    
    var nextEvoId: String {
        if _nextEvoId == nil {
            return "\(pokedexId)"
        }
        return _nextEvoId
    }
    
    var nextEvoSprite: String {
        if _nextEvoSprite == nil {
            return ""
        }
        return self._nextEvoSprite
    }
    
    var nextEvoName: String {
        if _nextEvoName == nil {
            return ""
        }
        return self._nextEvoName
    }
    
    init(_name: String!, _pokedexId: Int!) {
        self._name = _name
        self._pokedexId = _pokedexId
        
        
        self._pokemonURL = "\(URL_GLITCH_API)\(self._pokedexId!)"
        
        
        
    }
    
    func downloadPokemonDetails(completed: @escaping downloadComplete) {
        
        AF.request(self._pokemonURL).responseJSON { (response) in
            
            if let dictList = response.value as? [Dictionary<String, AnyObject>] {
                
                
                if dictList.count > 0 {
                    
                    let dict = dictList[0]
                    
                    if let height = dict["height"] as? String {
                        self._height = "\(height)"
                    }
                    
                    if let weight = dict["weight"] as? String {
                        self._weight = "\(weight)"
                    }
                    
                    if let types = dict["types"] as? [String], types.count > 0 {
                        self._type = types[0].capitalized
                        
                        
                        if types.count > 1 {
                            for x in 1..<types.count {
                                self._type += "/\(types[x].capitalized)"
                            }
                        }
                    }
                    
                    if let description = dict["description"] as? String {
                        self._description = description
                    }
                    
                   
                    if let abilities = dict["abilities"] as? Dictionary<String,AnyObject> {
                        if let normal = abilities["normal"] as? [String], normal.count > 0{
                            self._attack = normal[0].capitalized
                        }
                        if let hidden = abilities["hidden"] as? [String], hidden.count > 0 {
                            self._defense = hidden[0].capitalized
                        }
                    }
                    
                    if let family = dict["family"] as? Dictionary<String, AnyObject> {
                        if let evolutionStage = family["evolutionStage"] as? Int {
                            if let evolutionLineList = family["evolutionLine"] as? [String], evolutionLineList.count > 0 {
                                self._nextEvolutionTxt = "Evolution Line: \(evolutionLineList[0].capitalized)"
                                
                                if evolutionLineList.count > 1 {
                                    for x in 1..<evolutionLineList.count {
                                        self._nextEvolutionTxt += " → \(evolutionLineList[x].capitalized)"
                                        
                                        if x == evolutionStage {
                                            self._nextEvoName = evolutionLineList[x]
                                            print(self._nextEvoName)
                                        }
   
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            
            completed()
        }
        
        
        
    }
    
    func loadEvolutionData(completed: @escaping downloadComplete) {
        print("why am I called so early? :(", self._nextEvoName)
        
        if let nextEvoName = self._nextEvoName as? String {
            print("I am here with", nextEvoName)
            AF.request("\(URL_GLITCH_API)\(nextEvoName)").responseJSON {(response) in
                
                if let dictList = response.value as? [Dictionary<String,AnyObject>], dictList.count > 0 {
                    let dict = dictList[0]
                    if let number = dict["number"] as? String {
                        
                        self._nextEvoId = number
                        print(self._nextEvoId)
                        print("self", self._nextEvoId, self._nextEvoName)
                    }
                    if let sprite = dict["sprite"] as? String {
                        self._nextEvoSprite = sprite
                        
                        
                    }
                }
                completed()
            }
        } else {
            print("didn't find anything...")
            completed()
        }
        
        
    }
    
    
   
    
}
