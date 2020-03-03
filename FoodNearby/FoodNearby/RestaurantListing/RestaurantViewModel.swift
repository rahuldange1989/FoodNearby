//
//  RestaurantViewModel.swift
//  FoodNearby
//
//  Created by Rahul Dange on 02/03/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import Foundation

protocol RestaurantListUpdateDelegate {
	func updateRestaurantList(list: [Restaurant])
}

class RestaurantViewModel {
	
	var delegate: RestaurantListUpdateDelegate? = nil
	
	init() {
		
	}
	
	// MARK: - Internal Methods -
	func parseResponseJson() {
		if let path = Bundle.main.path(forResource: "RestaurantListResponse", ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
				let decoder = JSONDecoder()
				let restListResponse = try decoder.decode(RestaurantListResponse.self, from: data)
				
				// -- update restaurant list
				if let updateDelegate = self.delegate {
					updateDelegate.updateRestaurantList(list: restListResponse.restaurants)
				}
			} catch {
				print(error.localizedDescription)
			}
		}
	}
}
