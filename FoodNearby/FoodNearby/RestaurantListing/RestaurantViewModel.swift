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
	
	typealias SortDescriptor<Value> = (Value, Value) -> Bool
	var delegate: RestaurantListUpdateDelegate? = nil
	var favRestaurantList: [Restaurant] = []
	var nonFavRestList: [Restaurant] = []
	
	init() {
		
	}
	
	// MARK: - Internal Methods -
	func getUserSelectedSortDescriptor(option: String) -> SortDescriptor<Restaurant> {
		var sortDescriptor: SortDescriptor<Restaurant>?
		switch SortOptions.init(rawValue: option) {
			case .bestMatch:
				sortDescriptor = { ($0.sortingValues.bestMatch ?? 0.0) > ($1.sortingValues.bestMatch ?? 0.0) }
			
			case .newest:
				sortDescriptor = { ($0.sortingValues.newest ?? 0.0) > ($1.sortingValues.newest ?? 0.0) }
			
			case .ratingAverage:
				sortDescriptor = { ($0.sortingValues.ratingAverage ?? 0.0) > ($1.sortingValues.ratingAverage ?? 0.0) }
			
			case .distance:
				sortDescriptor = { ($0.sortingValues.distance ?? 0.0) < ($1.sortingValues.distance ?? 0.0) }
			
			case .popularity:
				sortDescriptor = { ($0.sortingValues.popularity ?? 0.0) > ($1.sortingValues.popularity ?? 0.0) }
			
			case .averageProductPrice:
				sortDescriptor = { ($0.sortingValues.averageProductPrice ?? 0.0) < ($1.sortingValues.averageProductPrice ?? 0.0) }
			
			case .deliveryCosts:
				sortDescriptor = { ($0.sortingValues.deliveryCosts ?? 0.0) < ($1.sortingValues.deliveryCosts ?? 0.0) }
			
			case .minCost:
				sortDescriptor = { ($0.sortingValues.minCost ?? 0.0) < ($1.sortingValues.minCost ?? 0.0) }
			
			case .none:
				sortDescriptor = { ($0.sortingValues.bestMatch ?? 0.0) > ($1.sortingValues.bestMatch ?? 0.0) }
		}
		return sortDescriptor!
	}
	
	func divideRestaurantByFavourite(mainList: [Restaurant]) {
		if let savedFavNames = UserDefaults.standard.value(forKey: "favouriteRestaurants") as? [String] {
			for restaurant in mainList {
				if savedFavNames.contains(restaurant.name) {
					restaurant.isFavourite = true
					self.favRestaurantList.append(restaurant)
				} else {
					self.nonFavRestList.append(restaurant)
				}
			}
		} else {
			self.nonFavRestList = mainList
		}
	}
	
	func markRestaurantAsFavourite(restaurant: Restaurant) {
		// -- add to favourite list
		self.favRestaurantList.append(restaurant)
		// -- remove to non-favourite list
		if let index = self.nonFavRestList.firstIndex(where: { $0 == restaurant }) {
			self.nonFavRestList.remove(at: index)
		}
		// -- save Restaurant name to UserDefaults
		var favArray = UserDefaults.standard.value(forKey: "favouriteRestaurants") as? [String] ?? []
		favArray.append(restaurant.name)
		UserDefaults.standard.set(favArray, forKey: "favouriteRestaurants")
		UserDefaults.standard.synchronize()
	}
	
	func parseResponseJson() {
		if let path = Bundle.main.path(forResource: "RestaurantListResponse", ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
				let decoder = JSONDecoder()
				let restListResponse = try decoder.decode(RestaurantListResponse.self, from: data)
				self.divideRestaurantByFavourite(mainList: restListResponse.restaurants)
				
				// -- update restaurant list
				self.sortRestaurants(with: "Best match")
			} catch {
				print(error.localizedDescription)
			}
		}
	}
	
	func sortRestaurants(with option: String) {
		// -- priority 3 sorting option based on user selection
		let selectedSortDescriptor = self.getUserSelectedSortDescriptor(option: option)
		
		let sortedFavList = self.sortRestaurantStatusWise(with: selectedSortDescriptor, subList: self.favRestaurantList)
		let sortedNonFavList = self.sortRestaurantStatusWise(with: selectedSortDescriptor, subList: self.nonFavRestList)
		
		// -- update restaurant list
		if let updateDelegate = self.delegate {
			updateDelegate.updateRestaurantList(list: sortedFavList + sortedNonFavList)
		}
	}
	
	func sortRestaurantStatusWise(with sortDescriptor: SortDescriptor<Restaurant>, subList: [Restaurant]) -> [Restaurant] {
		// -- default priority 2 sorting option (status wise) & then applying user selected option
		let openRestaurantsSorted = subList.filter { $0.status.rawValue == "open" }.sorted(by: sortDescriptor)
		let orderAheadRestaurantsSorted = subList.filter { $0.status.rawValue == "order ahead" }.sorted(by: sortDescriptor)
		let closedRestaurantsSorted = subList.filter { $0.status.rawValue == "closed" }.sorted(by: sortDescriptor)
		
		return openRestaurantsSorted + orderAheadRestaurantsSorted + closedRestaurantsSorted
	}
}
