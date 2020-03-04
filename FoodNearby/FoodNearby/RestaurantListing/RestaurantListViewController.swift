//
//  RestaurantListViewController.swift
//  FoodNearby
//
//  Created by Rahul Dange on 02/03/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit

class RestaurantListViewController: UIViewController {
	
	// -- outlets
	@IBOutlet weak var restaurantListTableView: UITableView!
	
	// -- internal variables
	let restaurantViewModel = RestaurantViewModel()
	let searchController = UISearchController(searchResultsController: nil) // -- for filtering restaurants by name
	var restaurantList: [Restaurant] = []
	var filteredList: [Restaurant] = []
	var isSearchBarEmpty: Bool {
		return searchController.searchBar.text?.isEmpty ?? true
	}
	var isFiltering: Bool {
	  return searchController.isActive && !isSearchBarEmpty
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		restaurantViewModel.delegate = self
		
		// -- initialize searchController
		self.initializeSearchController()
		
		// -- to hide extra lines
		restaurantListTableView.tableFooterView = .init()
		restaurantListTableView.tableHeaderView = searchController.searchBar
		
		// -- parse json and load tableview
		restaurantViewModel.parseResponseJson()
	}

	// MARK: - Internal Methods -
	func initializeSearchController() {
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search restaurants"
		definesPresentationContext = true
	}
	
	func filterContentForSearchText(_ searchText: String) {
		filteredList = restaurantList.filter { (restaurant: Restaurant) -> Bool in
			return restaurant.name.lowercased().contains(searchText.lowercased())
		}
		// -- update search results
		self.restaurantListTableView.reloadData()
	}
	
	func createSortActions(with actionArray: [SortOptions]) -> [UIAlertAction] {
		var alertActions: [UIAlertAction] = []
		for option in actionArray {
			let action = UIAlertAction.init(title: option.rawValueString(), style: .default) { (action) in
				// -- add sort action handler code
				self.restaurantViewModel.sortRestaurants(with: action.title ?? "")
			}
			alertActions.append(action)
		}
		// -- add cancel action
		let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
		alertActions.append(cancelAction)
		return alertActions
	}
	
	// MARK: - Event Handler Methods -
	@IBAction func sortBtnClicked(_ sender: Any) {
		let sortOptionsSheet = UIAlertController.init(title: "", message: "Choose sorting option", preferredStyle: .actionSheet)
		
		// -- add different sorting options
		let actions = self.createSortActions(with: [.bestMatch, .newest, .ratingAverage, .distance, .popularity, .averageProductPrice, .deliveryCosts, .minCost])
		for action in actions {
			sortOptionsSheet.addAction(action)
		}
		
		// -- present action sheet
		self.present(sortOptionsSheet, animated: true, completion: nil)
	}
	
	@objc func handleFavouriteBtnClickEvent(btn: UIButton) {
		var restaurant: Restaurant
		if isFiltering {
			restaurant = self.filteredList[btn.tag]
		} else {
			restaurant = self.restaurantList[btn.tag]
		}
		if (restaurant.isFavourite ?? false) {
			self.restaurantViewModel.markRestaurantAsNonFavourite(restaurant: restaurant)
		} else {
			self.restaurantViewModel.markRestaurantAsFavourite(restaurant: restaurant)
		}
	}
}

// MARK: - RestaurantListUpdateDelegate methods -
extension RestaurantListViewController : RestaurantListUpdateDelegate {
	func updateRestaurantList(list: [Restaurant]) {
		self.restaurantList = list
		DispatchQueue.main.async {
			self.restaurantListTableView.reloadData()
		}
	}
}

// MARK: - UITableView Data Source methods -
extension RestaurantListViewController : UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isFiltering {
			return filteredList.count
		}
		return restaurantList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var restaurantCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as? RestaurantCell
		
		if restaurantCell == nil {
			restaurantCell = UITableViewCell.init(style: .default, reuseIdentifier: "RestaurantCell") as? RestaurantCell
		}
		
		if isFiltering {
			restaurantCell?.setupCell(restaurant: filteredList[indexPath.row])
		} else {
			restaurantCell?.setupCell(restaurant: restaurantList[indexPath.row])
		}
		
		// -- enable favourite restaurant btn
		restaurantCell?.favouriteBtn.tag = indexPath.row
		restaurantCell?.favouriteBtn.addTarget(self, action: #selector(self.handleFavouriteBtnClickEvent(btn:)), for: .touchUpInside)
		
		return restaurantCell!
	}
}

// MARK: - UISearchResultUpdating methods for search controller-
extension RestaurantListViewController : UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		self.filterContentForSearchText(searchBar.text!)
	}
}
