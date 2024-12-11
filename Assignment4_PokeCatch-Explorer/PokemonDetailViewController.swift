//
//  PokemonDetailViewController.swift
//  Assignment4_PokeCatch-Explorer
//
//  Created by user on 2024-12-10.
//

import UIKit

class PokemonDetailViewController: UIViewController {

    // Outlets for UI elements
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonDescriptionLabel: UILabel!
    @IBOutlet weak var catchButton: UIButton!
   
        // Variables to receive data from the previous screen
        var pokemonName: String?
        var pokemonImageURL: String?

        override func viewDidLoad() {
            super.viewDidLoad()

            // Set up the UI
            setupUI()
            fetchPokemonDetails() // Fetch Pokémon details (description and image)

            // Add "Caught" button to the navigation bar
            let caughtButton = UIBarButtonItem(title: "Caught", style: .plain, target: self, action: #selector(openCaughtPokemons))
            navigationItem.rightBarButtonItem = caughtButton
        }

        @objc func openCaughtPokemons() {
            let caughtPokemonsVC = storyboard?.instantiateViewController(withIdentifier: "CaughtPokemonsViewController") as! CaughtPokemonsViewController
            navigationController?.pushViewController(caughtPokemonsVC, animated: true)
        }

        // MARK: - UI Setup
        private func setupUI() {
            // Set Pokémon name
            pokemonNameLabel.text = pokemonName?.capitalized ?? "Unknown"

            // Set default description
            pokemonDescriptionLabel.text = "Loading description..."
            pokemonDescriptionLabel.numberOfLines = 0 // Allow multi-line text
            pokemonDescriptionLabel.lineBreakMode = .byWordWrapping // Wrap text by words
        }

        // MARK: - Fetch Pokémon Details
        private func fetchPokemonDetails() {
            guard let pokemonName = pokemonName else { return }

            // Fetch description and image
            PokemonAPI.shared.fetchPokemonDetails(for: pokemonName) { [weak self] _, imageURL in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let imageURL = imageURL, let url = URL(string: imageURL) {
                        self.pokemonImageURL = imageURL // Save the URL for later use
                        DispatchQueue.global().async {
                            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self.pokemonImageView.image = image
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.pokemonImageView.image = UIImage(systemName: "photo") // Placeholder
                                }
                            }
                        }
                    } else {
                        self.pokemonImageView.image = UIImage(systemName: "photo") // Placeholder
                    }
                }
            }

            // Fetch description
            PokemonAPI.shared.fetchPokemonSpecies(for: pokemonName) { [weak self] description in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let description = description {
                        let cleanedDescription = description.replacingOccurrences(of: "\n", with: " ")
                                                               .replacingOccurrences(of: "  ", with: " ")
                        self.pokemonDescriptionLabel.text = cleanedDescription
                    } else {
                        self.pokemonDescriptionLabel.text = "No description available."
                    }
                    self.pokemonDescriptionLabel.sizeToFit()
                    self.view.layoutIfNeeded()
                }
            }
        }

        // MARK: - Catch Pokémon Action
        @IBAction func catchPokemonTapped(_ sender: UIButton) {
            guard let pokemonName = pokemonName, let imageURL = pokemonImageURL else {
                showAlert(title: "Error", message: "Failed to catch Pokémon.")
                return
            }

            // Random success/failure for catching Pokémon
            let success = Bool.random()
            if success {
                CoreDataManager.shared.addCaughtPokemon(name: pokemonName, imageURL: imageURL)
                showAlert(title: "Success!", message: "You caught \(pokemonName.capitalized)!")
            } else {
                showAlert(title: "Oops!", message: "\(pokemonName.capitalized) escaped!")
            }
        }

        // MARK: - Helper: Show Alert
        private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
