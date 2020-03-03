//
//  RatingView.swift
//  FoodNearby
//
//  Created by Rahul Dange on 03/03/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit

class RatingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	// -- rating for star view
	var rating: Double = 0.0 {
		didSet {
			var r = rating > 5.0 ? 5.0 : rating
			for i in 0...4 {
				let curStar = starImageArray[i]
				var imageName = "star.fill"
				
				if r < 0.1 {
					imageName = "star"
				} else if r < 1.0 {
					imageName = "star.lefthalf.fill"
				} else {
					
				}
				
				curStar.image = UIImage.init(systemName: imageName)
				r = r - 1.0
			}
		}
	}
	
	var starImageArray: [UIImageView] = []
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		// -- add stars
		self.addFiveEmptyStars()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.addFiveEmptyStars()
	}
	
	// MARK: - Internal methods -
	func addFiveEmptyStars() {
		for i in 0...4 {
			let imageView = UIImageView.init(frame: CGRect.init(x: Double(i * 18) + (i == 0 ? 0.0 : 3.0), y: 0, width: 18.0, height: 18.0))
			imageView.tintColor = UIColor.systemOrange
			imageView.image = UIImage.init(systemName: "star")
			starImageArray.append(imageView)
			addSubview(imageView)
		}
	}
}
