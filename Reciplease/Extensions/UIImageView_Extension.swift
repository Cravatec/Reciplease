//
//  UIImageView_Extension.swift
//  Reciplease
//
//  Created by Sam on 22/09/2022.
//

import Foundation
import UIKit

extension UIImageView {
    func imageLoadingFromURL(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.image = nil
                }
            }
        }
    }
}
