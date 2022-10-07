//
//  FavoriteRacipesTableViewController.swift
//  Reciplease
//
//  Created by Sam on 07/10/2022.
//

import UIKit

class FavoriteRacipesTableViewController: UITableViewController {

    private let coreDataService = CoreDataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataService.retrieve()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
}
