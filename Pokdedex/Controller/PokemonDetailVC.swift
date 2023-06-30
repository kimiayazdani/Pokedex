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
    @IBOutlet weak var littleArrowImg: UIImageView!
    
    @IBOutlet weak var normalAbilityLbl: UILabel!
    
    var overviewMode = true
    var pokemon: Pokemon!

    // Override View Functions
    override func viewDidLoad() {
        print("i am in view did load")
        super.viewDidLoad()
        
        idLbl.text = "\(pokemon.pokedexId)"
        mainImg.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokedoxHollow.text = pokemon.name
        pkedoxSolid.text = pokemon.name
        
        let currentImgURL = URL(string: "\(IMAGE_BASE_URL)\(pokemon.pokedexId).png")!
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: currentImgURL)
                    DispatchQueue.main.sync {
                        self.currentEvoImg.image = UIImage(data: data)
                    }
            } catch  {
                print("couldn't load the currentEvo image:")
                self.currentEvoImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
            }
        }
        
        pokemon.downloadPokemonDetails {
            self.updateUI()
            

                self.pokemon.loadEvolutionData {
                    self.updateEvolutionImg()
                }
            
        }
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextEvoTapped(_:)))
         nextEvoImg.addGestureRecognizer(tapGesture)
         nextEvoImg.isUserInteractionEnabled = true
        


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
    
    @objc func nextEvoTapped(_ sender: UITapGestureRecognizer) {
        print(pokemon.nextEvoName, pokemon.nextEvoId, pokemon.pokedexId)
        if pokemon.nextEvoName != "" , pokemon.nextEvoId != "\(self.pokemon.pokedexId)"{
            print("here I am")
            let pokeNew = Pokemon(_name: pokemon.nextEvoName, _pokedexId: Int(pokemon.nextEvoId))
            self.pokemon = pokeNew
            self.viewDidLoad()
        }
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
        DescriptionLbl.text = pokemon.description
        nextEvoLbl.text = pokemon.nextEvolutionTxt
        

        
    }

    
    func updateEvolutionImg() {
        if self.pokemon.nextEvoSprite == "" {
            self.nextEvoImg.isHidden = true
            self.littleArrowImg.isHidden = true
        }
        else {
            let nextImgURL = URL(string: self.pokemon.nextEvoSprite)!
            
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: nextImgURL)
                    DispatchQueue.main.sync {
                        self.nextEvoImg.image = UIImage(data: data)
                    }
                } catch  {
                    print("couldn't load the nextEvo image:")
                    self.nextEvoImg.image = UIImage(named: "\(self.pokemon.nextEvoId)")
                }
            }
            
        }
    }

}
