//
//  ViewController.swift
//  Pokdedex
//
//  Created by Kimia Yazdani on 6/29/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    // Variables
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var upperBar: UIView!
    
    
    @IBOutlet weak var upperBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var upperBarHeightLandscapeConstraint: NSLayoutConstraint!
    @IBOutlet weak var pokedexCenterConstraint: NSLayoutConstraint!
    
    var musicPlayer: AVAudioPlayer!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var inSearchMode = false
    // View Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
        searchBar.backgroundColor = .white
        
        initAudio()
        parsePokemonCSV()
        searchBar.returnKeyType = UIReturnKeyType.done
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { context in
            self.updateViewHeightForOrientation()
        }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPokeDetail" {
            if let destination = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    destination.pokemon = poke
                }
            }
        }
    }

    
    // Actions
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 0.5
        }
    }
    
    
    // Protocol Functions
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
            var pokemon = pokemons[indexPath.row]
            if inSearchMode == true {
                pokemon = filteredPokemons[indexPath.row]
            }
            cell.configureCell(pokemon: pokemon)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var pokemon = pokemons[indexPath.row]
        if inSearchMode == true {
            pokemon = filteredPokemons[indexPath.row]
        }
        performSegue(withIdentifier: "ShowPokeDetail", sender: pokemon)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode == false {
            return pokemons.count
        } else {
            return filteredPokemons.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            
            filteredPokemons = pokemons.filter({$0.name.lowercased().contains(lower)})
            
            collection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.inSearchMode = false
        searchBar.resignFirstResponder()
        collection.reloadData()
        view.endEditing(true)
    }
    
    // Utilities
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokemon = Pokemon(_name: row["identifier"]!, _pokedexId: Int(row["id"]!)!)
                pokemons.append(pokemon)
            }
        } catch let err as NSError {
            print(err.localizedDescription.debugDescription)
        }
    }
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
//            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.localizedDescription.debugDescription)
        }
    }
    
    private func updateViewHeightForOrientation() {
           if traitCollection.verticalSizeClass == .compact {
               // Landscape orientation
               upperBarHeightConstraint.isActive = false
               upperBarHeightLandscapeConstraint.isActive = true
               pokedexCenterConstraint.constant = 5

           } else {
               // Portrait or other orientations
               upperBarHeightLandscapeConstraint.isActive = false
               upperBarHeightConstraint.isActive = true
               pokedexCenterConstraint.constant = 25

           }
        view.layoutIfNeeded()
       }

    
    
}

