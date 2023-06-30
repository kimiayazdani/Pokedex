//
//  PokeCell.swift
//  Pokdedex
//
//  Created by Kimia Yazdani on 6/29/23.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var pokeImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    func configureCell(pokemon: Pokemon){
        self.pokemon = pokemon
        self.pokeImg.image = UIImage(named: "\(pokemon.pokedexId)")
        self.nameLbl.text = pokemon.name.capitalized
    }
    
    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 10.0
    }
}
