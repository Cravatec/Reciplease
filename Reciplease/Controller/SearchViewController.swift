//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Sam on 31/08/2022.
//

import UIKit
import Alamofire

class SearchViewController: UITableViewController {
    var recipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AlamoFireFetchingRecipes.getRecipes(ingredients: "avocado") { [weak self] result in
                        guard let self = self else { return }
                        }
    }
}
