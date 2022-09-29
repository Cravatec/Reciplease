//
//  IngredientTableViewCell.swift
//  Reciplease
//
//  Created by Sam on 29/09/2022.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientImage: UIImageView!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    func configureCell(with url: URL?, ingredientText: String) {
        if let url = url {
            ingredientImage.imageLoadingFromURL(url: url)
        }
        ingredientImage.layer.cornerRadius = ingredientImage.frame.height / 2
        ingredientLabel.text = ingredientText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
