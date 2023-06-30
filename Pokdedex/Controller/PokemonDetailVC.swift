//
//  PokemonDetailVC.swift
//  Pokdedex
//
//  Created by Kimia Yazdani on 6/29/23.
//

import UIKit

class PokemonDetailVC: UIViewController {
    // Variables and Outlets
    @IBOutlet weak var nameLbl: UILabel!
    var pokemon: Pokemon!

    // Override View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name

        
    }
    


}
