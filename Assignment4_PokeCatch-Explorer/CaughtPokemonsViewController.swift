//
//  CaughtPokemonsViewController.swift
//  Assignment4_PokeCatch-Explorer
//
//  Created by user on 2024-12-10.
//

import UIKit

class CaughtPokemonsViewController: UIViewController {

    // Outlets for the table view
    @IBOutlet weak var tableView: UITableView!

        // Data source for caught Pokémon
        var caughtPokemons: [CaughtPokemon] = []

        override func viewDidLoad() {
            super.viewDidLoad()

            // Set up the table view delegate and data source
            tableView.delegate = self
            tableView.dataSource = self

            // Fetch caught Pokémon from Core Data
            fetchCaughtPokemons()

            // Add "Clear All" button to navigation bar
            let clearButton = UIBarButtonItem(title: "Clear All", style: .plain, target: self, action: #selector(clearAllCaughtPokemons))
            navigationItem.rightBarButtonItem = clearButton
        }

        // Fetch caught Pokémon from Core Data
        private func fetchCaughtPokemons() {
            caughtPokemons = CoreDataManager.shared.fetchCaughtPokemons()
            tableView.reloadData()
        }

        // Handle delete Pokémon functionality
        private func deletePokemon(at indexPath: IndexPath) {
            let pokemonToDelete = caughtPokemons[indexPath.row]
            CoreDataManager.shared.deleteCaughtPokemon(pokemonToDelete)
            caughtPokemons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        // Clear all caught Pokémon
        @objc private func clearAllCaughtPokemons() {
            let alert = UIAlertController(title: "Clear All", message: "Are you sure you want to delete all caught Pokémon?", preferredStyle: .alert)

            // Confirm action
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                CoreDataManager.shared.deleteAllCaughtPokemons()
                self.caughtPokemons.removeAll()
                self.tableView.reloadData()
            }))

            // Cancel action
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            present(alert, animated: true)
        }
    }

    // MARK: - UITableViewDelegate and UITableViewDataSource
    extension CaughtPokemonsViewController: UITableViewDelegate, UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return caughtPokemons.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CaughtPokemonCell", for: indexPath)

            // Access ImageView and Label using their tags
            guard let imageView = cell.viewWithTag(1) as? UIImageView,
                  let nameLabel = cell.viewWithTag(2) as? UILabel else {
                return cell
            }

            let caughtPokemon = caughtPokemons[indexPath.row]
            nameLabel.text = caughtPokemon.name?.capitalized

            // Load Pokémon image
            if let imageURL = caughtPokemon.imageURL, let url = URL(string: imageURL) {
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

            return cell
        }

        // Handle row selection
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedPokemon = caughtPokemons[indexPath.row]
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as! PokemonDetailViewController

            // Pass data to the detail view controller
            detailVC.pokemonName = selectedPokemon.name

            // Navigate to the detail view controller
            navigationController?.pushViewController(detailVC, animated: true)
        }

        // Enable swipe-to-delete functionality
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
                guard let self = self else { return }
                self.deletePokemon(at: indexPath)
                completionHandler(true)
            }
            deleteAction.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
