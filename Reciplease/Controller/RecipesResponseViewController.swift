//
//  RecipesResponseViewController.swift
//  Reciplease
//
//  Created by Sam on 15/09/2022.
//

import Foundation
import UIKit

protocol SearchViewControllerDelegate {
    func didFinishLoadingRecipes( _ recipes: [Recipe])
}

class RecipesResponseViewController: UIViewController {
    
    var recipes = [Recipe]()
    
    
    @IBOutlet weak var recipesResponseTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
    }
    
}

extension RecipesResponseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesResponseTable", for: indexPath) as? RecipesResponseTableViewCell
        let recipe = recipes[indexPath.row]
        cell?.recipeImage.image = UIImage(named: "default_Image.jpg")
        if let url = recipe.image {
            cell?.recipeImage.imageLoadingFromURL(url: url)
        }
        cell?.recipeTitleLabel.text = recipe.title!
        cell!.recipeTimeLabel.text = "🕐 \(String(describing: recipe.time!))"
        cell?.recipeNoteLabel.text  = "❤️ \(String(describing: recipe.like!))"
        cell?.recipeIngredientsLabel.text = recipe.detailIngredients!
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
