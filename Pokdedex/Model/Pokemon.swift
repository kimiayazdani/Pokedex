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
    
    private var _pokemonURL: String!
    private var _descriptionURL: String!
     
    var name: String {
        return _name.capitalized
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = "-"
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
        // returns the first ability instead
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
        // I am using order instead of this.
        if _defense == nil {
            _defense = "-"
        }
        return _defense
    }
    
    init(_name: String!, _pokedexId: Int!) {
        self._name = _name
        self._pokedexId = _pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId!)"
        
        
        self._descriptionURL = "\(URL_BASE)\(URL_DESCRIPTIONS)\(self._pokedexId!)/"
        
        self._pokemonURL = "\(URL_GLITCH_API)\(self._pokedexId!)"
        
    }
    
    func downloadPokemonDetails(completed: @escaping downloadComplete) {
        
        AF.request(self._pokemonURL).responseJSON { (response) in
            
            if let dict = response.value as? Dictionary<String, AnyObject> {
                print(dict)
                
                if let height = dict["height"] as? Int {
                    self._height = "\(height)"
                }
                
                if let weight = dict["weight"] as? Int {
                    self._weight = "\(weight)"
                }
                
                
                    
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String,AnyObject>], types.count > 0 {
                    if let type = types[0]["type"] as? Dictionary<String,AnyObject> {
                        if let name = type["name"] as? String {
                            self._type = name.capitalized
                        }
                    }
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let typ = types[x]["type"] as? Dictionary<String, AnyObject> {
                                if let name = typ["name"] as? String {
                                    self._type += "/\(name.capitalized)"
                                }
                            }
                        }
                    }
                }
                
                
                if let order = dict["order"] as? Int {
                    self._defense = "\(order)"
                }
                
                if let abilities = dict["abilities"] as? [Dictionary<String,AnyObject>] {
                    if abilities.count > 0 {
                        if  let ability = abilities[0]["ability"] as? Dictionary<String,AnyObject> {
                            if let name = ability["name"] as? String {
                                self._attack = name.capitalized
                            }
                            
                        }
                    }
                }
                
                
            }
            
            completed()
        }
    }
    
    func downloadPokemonDescriptions(completed: @escaping downloadComplete) {
        AF.request(self._descriptionURL).responseJSON { (response) in
            
            if let dict = response.value as? Dictionary<String, AnyObject> {
                print(" at least I am here ... ")
                if let descriptions = dict["descriptions"] as? [Dictionary<String, AnyObject>] {
                    
                    print(" i reached this point ")
                    if descriptions.count > 0 {
                        if let desc = descriptions[0]["description"] as? String {
                            self._description = desc
                        }
//
                        if descriptions.count > 1 {
                            for x in 1..<descriptions.count {
                                if let lang = descriptions[x]["language"] as? Dictionary<String, AnyObject> {
                                    if let name = lang["name"] as? String, name == "en" {
                                        if let desc = descriptions[x]["description"] as? String {
                                            self._description = "\(desc.capitalized)."
                                        }
                                        break
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
    
}
