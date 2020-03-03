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
	var restaurantList: [Restaurant] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		restaurantViewModel.delegate = self
		
		// -- to hide extra lines
		restaurantListTableView.tableFooterView = .init()
		
		// -- parse json and load tableview
		restaurantViewModel.parseResponseJson()
	}

	// MARK: - Internal Methods -
	
	// MARK: - Event Handler Methods -
	@IBAction func sortBtnClicked(_ sender: Any) {
		let sortOptionsSheet = UIAlertController.init(title: "", message: "Choose sorting option", preferredStyle: .actionSheet)
		
		// -- add different sorting options
		
		
		self.present(sortOptionsSheet, animated: true, completion: nil)
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
		return restaurantList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var restaurantCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as? RestaurantCell
		
		if restaurantCell == nil {
			restaurantCell = UITableViewCell.init(style: .default, reuseIdentifier: "RestaurantCell") as? RestaurantCell
		}
		
		restaurantCell?.setupCell(restaurant: restaurantList[indexPath.row])
		return restaurantCell!
	}
}
