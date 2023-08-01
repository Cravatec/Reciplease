//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Sam on 31/08/2022.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var delegate: SearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ingredientTableView.reloadData()
    }
    
    @IBAction func SearchRecipes(_ sender: Any) {
        let ingredients = IngredientService.shared.ingredients.map{$0.name}
        
        AlamoFireFetchingRecipes.getRecipes(ingredients: ingredients.joined(separator: ",")) { [weak self] result in
            if case .success(let recipes) = result {
                self?.delegate?.didFinishLoadingRecipes(recipes)
            }
        }
    }
    
    @IBAction func addIngredient(_ sender: Any) {
        guard let addIngredient = ingredientTextField.text else { return }
        let ingredient = Ingredient(name: addIngredient)
        do {
            try IngredientService.shared.add(ingredient: ingredient)
        } catch IngredientServiceError.alreadyExist {
            alertMessage(message: "This ingredient is already present.")
        } catch {
            
        }
        ingredientTableView.reloadData()
        ingredientTextField.text = ""
        ingredientTextField.resignFirstResponder()
        searchButton.isEnabled = true
    }
    
    @IBAction func clearActionButton(_ sender: Any) {
        IngredientService.shared.clear()
        ingredientTableView.reloadData()
        searchButton.isEnabled = false
    }
    
    
    
    private func alertMessage(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            let recipesResultViewController = segue.destination as? RecipesResponseViewController
            self.delegate = recipesResultViewController
        }
    }
}
// MARK: - Extension for keyboard

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ ingredientTextField: UITextField) -> Bool {
        ingredientTextField.resignFirstResponder()
        return true
    }
}

// MARK: - Extension for tableView

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in ingredientTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ ingredientTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IngredientService.shared.ingredients.count
    }
    
    func tableView(_ ingredientTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientTableView.dequeueReusableCell(withIdentifier: "IngredientsTable", for: indexPath)
        let ingredient = IngredientService.shared.ingredients[indexPath.row]
        cell.textLabel?.text = "✅\(ingredient.name)"
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ ingredientTableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        IngredientService.shared.remove(at: indexPath.row)
        ingredientTableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
