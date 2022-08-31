//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Sam on 31/08/2022.
//

import UIKit
import Alamofire

class SearchViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AlamoFireFetchingRecipes.getRecipes(ingredients: "chicken", "avocado")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
