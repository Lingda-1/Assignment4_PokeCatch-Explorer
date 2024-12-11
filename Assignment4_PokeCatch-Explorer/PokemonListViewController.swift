//
//  PokemonListViewController.swift
//  Assignment4_PokeCatch-Explorer
//
//  Created by user on 2024-12-10.
//

import UIKit

class PokemonListViewController: UIViewController {

    // Outlets for the table view and activity indicator
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

        // Data source for the Pokémon list
        var pokemonList: [Pokemon] = []

        override func viewDidLoad() {
            super.viewDidLoad()

            // Add a "Caught" button to the navigation bar
            let caughtButton = UIBarButtonItem(title: "Caught", style: .plain, target: self, action: #selector(openCaughtPokemons))
            navigationItem.rightBarButtonItem = caughtButton

            // Set table view delegate and data source
            tableView.delegate = self
            tableView.dataSource = self

            // Start the activity indicator
            activityIndicator.startAnimating()

            // Fetch the Pokémon list from the API
            fetchPokemonList()
        }

        @objc func openCaughtPokemons() {
            let caughtPokemonsVC = storyboard?.instantiateViewController(withIdentifier: "CaughtPokemonsViewController") as! CaughtPokemonsViewController
            navigationController?.pushViewController(caughtPokemonsVC, animated: true)
        }

        // Fetch Pokémon list from API and reload table view
        func fetchPokemonList() {
            PokemonAPI.shared.fetchPokemonList { [weak self] pokemonList in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating() // Stop the activity indicator
                    if let pokemonList = pokemonList {
                        self?.pokemonList = pokemonList
                        self?.tableView.reloadData()
                    } else {
                        // Handle error: show an alert
                        self?.showErrorAlert()
                    }
                }
            }
        }

        // Show error alert if the API call fails
        func showErrorAlert() {
            let alert = UIAlertController(title: "Error", message: "Failed to load Pokémon. Please try again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }

        // Handle Pokémon catch logic
        func catchPokemon(_ pokemon: Pokemon) {
            let success = Bool.random() // Randomly decide if the Pokémon is caught
            if success {
                CoreDataManager.shared.addCaughtPokemon(name: pokemon.name, imageURL: "")
                showCatchResultAlert(message: "You successfully caught \(pokemon.name.capitalized)!")
            } else {
                showCatchResultAlert(message: "Oh no! \(pokemon.name.capitalized) escaped!")
            }
        }

        // Show catch result alert
        func showCatchResultAlert(message: String) {
            let alert = UIAlertController(title: "Catch Result", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }

        // Helper to check if a Pokémon is caught
        private func isPokemonCaught(name: String) -> Bool {
            return CoreDataManager.shared.isPokemonCaught(name: name)
        }
    }

    // MARK: - UITableViewDelegate and UITableViewDataSource
    extension PokemonListViewController: UITableViewDelegate, UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return pokemonList.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)

            // Access ImageView and Label using their tags
            guard let imageView = cell.viewWithTag(1) as? UIImageView,
                  let nameLabel = cell.viewWithTag(2) as? UILabel else {
                return cell
            }

            let pokemon = pokemonList[indexPath.row]
            nameLabel.text = pokemon.name.capitalized

            // Load Pokémon image dynamically
            PokemonAPI.shared.fetchPokemonDetails(for: pokemon.name) { _, imageURL in
                DispatchQueue.main.async {
                    if let imageURL = imageURL, let url = URL(string: imageURL) {
                        DispatchQueue.global().async {
                            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    imageView.image = image
                                }
                            } else {
                                DispatchQueue.main.async {
                                    imageView.image = UIImage(systemName: "photo") // Placeholder
                                }
                            }
                        }
                    } else {
                        imageView.image = UIImage(systemName: "photo") // Placeholder
                    }
                }
            }

            // Check if Pokémon is caught and mark it
            if isPokemonCaught(name: pokemon.name) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }

            return cell
        }

        // Handle row selection
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedPokemon = pokemonList[indexPath.row]
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as! PokemonDetailViewController

            // Pass data to the detail view controller
            detailVC.pokemonName = selectedPokemon.name

            // Navigate to the detail view controller
            navigationController?.pushViewController(detailVC, animated: true)
        }

        // Add swipe-to-catch functionality
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let catchAction = UIContextualAction(style: .normal, title: "Catch") { [weak self] (action, view, completionHandler) in
                let pokemon = self?.pokemonList[indexPath.row]
                if let pokemon = pokemon {
                    self?.catchPokemon(pokemon)
                }
                completionHandler(true)
            }
            catchAction.backgroundColor = .systemBlue
            return UISwipeActionsConfiguration(actions: [catchAction])
        }
    }
