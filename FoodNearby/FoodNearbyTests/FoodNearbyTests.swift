//
//  FoodNearbyTests.swift
//  FoodNearbyTests
//
//  Created by Rahul Dange on 02/03/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import XCTest
@testable import FoodNearby

class FoodNearbyTests: XCTestCase {

	var sut: RestaurantListViewController!
	
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		super.setUp()
		sut = RestaurantListViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		sut = nil
		super.tearDown()
    }

	// -- Test if json file exists and decodable
	func testJsonFileExistsAndDecodable() throws {
		// -- When the Data initializer is throwing an error, the test will fail.
		let path = Bundle.main.path(forResource: "RestaurantListResponse", ofType: "json")!
		let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
		
		// -- The `XCTAssertNoThrow` can be used to get extra context about the throw
		XCTAssertNoThrow(try JSONDecoder().decode(RestaurantListResponse.self, from: jsonData))
	}
	
	// -- Test if parsing JSON methods works
    func testParseResponseJson() {
        sut.restaurantViewModel.parseResponseJson()
		XCTAssertLessThan(sut.restaurantList.count, 1, "Failed to parse json file and generate restaurant list")
	}

	// -- Test if sort restaurant works
	func testSortRerstaurants() {
		let rest1 = Restaurant.init(name: "ABC", status: Status(rawValue: "closed")!, sortingValues: SortingValues.init(bestMatch: 6.0, newest: 118.0, ratingAverage: 4.0, distance: 2153, popularity: 9.0, averageProductPrice: 1103, deliveryCosts: 150, minCost: 1500), isFavourite: false)
		let rest2 = Restaurant.init(name: "DEF", status: Status(rawValue: "open")!, sortingValues: SortingValues.init(bestMatch: 10.0, newest: 201.0, ratingAverage: 4.0, distance: 2353, popularity: 25.0, averageProductPrice: 968, deliveryCosts: 0, minCost: 2000), isFavourite: false)
		let rest3 = Restaurant.init(name: "GHI", status: Status(rawValue: "order ahead")!, sortingValues: SortingValues.init(bestMatch: 12.0, newest: 231.0, ratingAverage: 4.5, distance: 3957, popularity: 79.0, averageProductPrice: 1762, deliveryCosts: 99, minCost: 1300), isFavourite: false)
		
		var sortDescriptor = sut.restaurantViewModel.getUserSelectedSortDescriptor(option: "Rating average")
		var results = sut.restaurantViewModel.sortRestaurantStatusWise(with: sortDescriptor, subList: [rest1, rest2, rest3])
		XCTAssertEqual(results.first?.name, "DEF", "Problem with sorting option Rating Average.")
		
		sortDescriptor = sut.restaurantViewModel.getUserSelectedSortDescriptor(option: "Distance")
		results = sut.restaurantViewModel.sortRestaurantStatusWise(with: sortDescriptor, subList: [rest1, rest2, rest3])
		XCTAssertEqual(results.first?.name, "DEF", "Problem with sorting option Distance.")
	}
	
	// -- Test if mark restaurant favourite works
	func testIfMarkRestaurantFavouriteWorks() {
		let rest1 = Restaurant.init(name: "DEF", status: Status(rawValue: "open")!, sortingValues: SortingValues.init(bestMatch: 10.0, newest: 201.0, ratingAverage: 4.0, distance: 2353, popularity: 25.0, averageProductPrice: 968, deliveryCosts: 0, minCost: 2000), isFavourite: false)
		sut.restaurantViewModel.markRestaurantAsFavourite(restaurant: rest1)
		XCTAssertTrue(rest1.isFavourite!, "Marking restaurant favourite method not working")
	}
	
	// -- Test if mark restaurant non-favourite works
	func testIfMarkRestaurantNonFavouriteWorks() {
		let rest1 = Restaurant.init(name: "DEF", status: Status(rawValue: "open")!, sortingValues: SortingValues.init(bestMatch: 10.0, newest: 201.0, ratingAverage: 4.0, distance: 2353, popularity: 25.0, averageProductPrice: 968, deliveryCosts: 0, minCost: 2000), isFavourite: true)
		sut.restaurantViewModel.markRestaurantAsNonFavourite(restaurant: rest1)
		XCTAssertFalse(rest1.isFavourite!, "Marking restaurant favourite method not working")
	}
}
