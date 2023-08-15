//
//  RecipesResponseViewController.swift
//  Reciplease
//
//  Created by Sam on 15/09/2022.
//

import Foundation
import UIKit
import CoreData

protocol SearchViewControllerDelegate {
    func didFinishLoadingRecipes( _ recipes: [Recipe])
}

class RecipesResponseViewController: UIViewController {
    
    var recipes = [Recipe]()
    private var selectedRecipe: Recipe?
    private let service: RecipeStorageService = CoreDataRecipeStorage()
    
    @IBOutlet weak var recipesResponseTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFavorites()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRecipe", let recipe = selectedRecipe {
            guard let recipeViewController = segue.destination as? RecipeViewController else { return }
            recipeViewController.selectedRecipe = recipe
        }
    }
}

extension RecipesResponseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell
        cell?.delegate = self
        let recipe = recipes[indexPath.row]
        cell?.recipeImage.image = UIImage(named: "default_Image.jpg")
        if let url = recipe.image {
            cell?.recipeImage.imageLoadingFromURL(url: url)
        }
        cell?.recipeTitleLabel.text = recipe.title!
        cell!.recipeTimeLabel.text = "🕐 \(String(describing: recipe.time!)) min"
        cell?.recipeNoteLabel.text  = "❤️ \(String(describing: recipe.like!)) Like"
        cell?.recipeIngredientsLabel.text = recipe.detailIngredients!
        guard CoreDataRecipeStorage.shared.isFavorite(recipeTitle: cell?.recipeTitleLabel.text ?? "")
                else {
            cell?.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            return cell ?? UITableViewCell()
                }
        cell?.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        return cell ?? UITableViewCell()
    }
}

extension RecipesResponseViewController: SearchViewControllerDelegate {
    func didFinishLoadingRecipes(_ recipes: [Recipe]) {
        self.recipes = recipes
        recipesResponseTableView.reloadData()
        activityIndicator.stopAnimating()
    }
}

extension RecipesResponseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = recipes[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueToRecipe", sender: self)
    }
}

extension RecipesResponseViewController: RecipeTableViewCellDelegate {
    func didTapFavoriteButton(cell: RecipeTableViewCell) {
        
        if let indexPath = recipesResponseTableView.indexPath(for: cell) {
            var recipe = recipes[indexPath.row]
            guard CoreDataRecipeStorage.shared.isFavorite(recipeTitle: recipe.title!)
            else {
                cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                service.save(recipe: recipe) { result in
                    recipesResponseTableView.reloadData()
                }
                return
            }
            cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            service.delete(recipe) { result in
                    cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)

            }
        }
    }
    
    private func reloadFavorites() {
        service.retrieve { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.recipesResponseTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
