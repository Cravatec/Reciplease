//
//  FavoriteRacipesTableViewController.swift
//  Reciplease
//
//  Created by Sam on 07/10/2022.
//

import UIKit
import CoreData

class FavoriteRecipesTableViewController: UITableViewController {
    
    @IBOutlet weak var noFavoriteLabel: UILabel!
    
    private var storageService: RecipeStorageService = CoreDataRecipeStorage()
    
    private var selectedRecipe: Recipe?
    
    private var favoriteRecipes: [Recipe] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFavorites()
    }
    
    private func configureNoFavoriteLabel() {
        if favoriteRecipes.isEmpty {
            noFavoriteLabel.isHidden = false
            noFavoriteLabel.text = """
You don’t have a favorite yet,
touch the ❤️ to add one
"""
        } else {
            noFavoriteLabel.isHidden = true
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        guard indexPath.row < favoriteRecipes.count else { return cell }
        let recipe = favoriteRecipes[indexPath.row]
        cell.recipeImage.image = UIImage(named: "default_Image.jpg")
        if let url = recipe.image {
            cell.recipeImage.imageLoadingFromURL(url: url)
        }
        cell.recipeTitleLabel.text = recipe.title
        cell.recipeTimeLabel.text = "🕐 \(String(describing: recipe.time!)) min"
        cell.recipeNoteLabel.text  = "❤️ \(String(describing: recipe.like!)) Like"
        let favoriteImage = UIImage(systemName: "heart.fill")
        cell.favoriteButton.setImage(favoriteImage, for: .normal)
        cell.delegate = self
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFavoriteToRecipe", let recipe = selectedRecipe {
            guard let recipeViewController = segue.destination as? RecipeViewController else { return }
            recipeViewController.selectedRecipe = recipe
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = favoriteRecipes[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueFavoriteToRecipe", sender: self)
    }
}

extension FavoriteRecipesTableViewController: RecipeTableViewCellDelegate {
    func didTapFavoriteButton(cell: RecipeTableViewCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            let recipe = favoriteRecipes[indexPath.row]
            storageService.delete(recipe) { [weak self] result in
                switch result {
                case .success:
                    self?.reloadFavorites()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func reloadFavorites() {
        storageService.retrieve { [weak self] result in
            switch result {
            case .success(let recipes):
                DispatchQueue.main.async {
                    self?.favoriteRecipes = recipes
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self?.configureNoFavoriteLabel()
            }
        }
    }
}
