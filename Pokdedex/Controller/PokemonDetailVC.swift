//
//  PokemonDetailVC.swift
//  Pokdedex
//
//  Created by Kimia Yazdani on 6/29/23.
//

import UIKit

class PokemonDetailVC: UIViewController {
    // Variables and Outlets
    @IBOutlet weak var pokedoxHollow: UILabel!
    @IBOutlet weak var pkedoxSolid: UILabel!
    
    

    @IBOutlet weak var propertiesView: UIStackView!
    @IBOutlet weak var midRedBar: UIView!
    @IBOutlet weak var evolutionView: UIView!
    
    
    
    
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var DescriptionLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    
    
    
    var pokemon: Pokemon!

    // Override View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idLbl.text = "\(pokemon.pokedexId)"
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokedoxHollow.text = pokemon.name
        pkedoxSolid.text = pokemon.name
        pokemon.downloadPokemonDetails {
            self.updateUI()
        }
        
        pokemon.downloadPokemonDescriptions {
            self.updateDescriptionUI()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { context in
            self.updateViewHeightForOrientation()
        }, completion: nil)
    }
    
    // Actions
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // Utilities
    private func updateViewHeightForOrientation() {
           if traitCollection.verticalSizeClass == .compact {
               // Landscape orientation
               propertiesView.isHidden = true
               evolutionView.isHidden = true

           } else {
               // Portrait or other orientations
               propertiesView.isHidden = false
               evolutionView.isHidden = false

           }
        view.layoutIfNeeded()
       }
    
    
    func updateUI() {
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        baseAttackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        typeLbl.text = pokemon.type
    }
    
    func updateDescriptionUI() {
        DescriptionLbl.text = pokemon.description
    }


}
