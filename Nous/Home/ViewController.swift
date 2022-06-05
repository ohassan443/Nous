	//
	//  ViewController.swift
	//  Nous
	//
	//  Created by Omar Hassan  on 05/06/2022.
	//

import UIKit
import Combine
import ImageCollectionLoader
class ViewController: UIViewController {

	@IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
	@IBOutlet weak var tableViewOutlet: UITableView!
	@IBOutlet weak var errorView: UIView!
	@IBOutlet weak var errorLabel: UILabel!
	@IBOutlet weak var searchBar: UISearchBar!

	fileprivate var subscriptions = Set<AnyCancellable>()
	fileprivate var viewModel = MenuItemsViewModel(menuItemsRepo: MenuItemsRepo())
	fileprivate var tableViewItems : [MenuItem] = []
	fileprivate var filtereditems : [MenuItem] {
		guard searchText != "" else {return tableViewItems}

		 return tableViewItems.filter({item in
			 item.itemDescription.lowercased().contains(searchText.lowercased()) ||  item.title.lowercased().contains(searchText.lowercased())
		})
	}
	fileprivate var searchText = ""
	fileprivate var imageCollectionLoader = ImageCollectionLoaderBuilder().defaultImp(ramMaxItemsCount: 50)
	override func viewDidLoad() {
		super.viewDidLoad()
		setupBindings()
		viewModel.loadEndPointData()
			// Do any additional setup after loading the view.
	}
	deinit {
		for sub in subscriptions{
			sub.cancel()
		}
	}
	private func setupBindings() {
		tableViewOutlet.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
		tableViewOutlet.rowHeight = UITableView.automaticDimension
		tableViewOutlet.delegate = self
		tableViewOutlet.dataSource = self
		tableViewOutlet.separatorStyle = .none
		tableViewOutlet.keyboardDismissMode = .onDrag
		searchBar.delegate = self



		viewModel.$menuItems.sink { [weak self] items in
			guard let self = self else{return}
			switch items {
			case .currentlyLoading , .accessedDataBeforeLoading :
				self.activityIndicatorOutlet.startAnimating()
				self.errorView.isHidden = true

			case .loaded(result: let result):
				self.activityIndicatorOutlet.stopAnimating()
				switch result {
				case .success(let loadedItems):
					guard loadedItems.isEmpty == false else {
						self.errorView.isHidden = false
						self.errorLabel.text = "No items to show right now" + "\n\n Tap to retry"
						return
					}
					self.errorView.isHidden = true
					self.tableViewItems = loadedItems
					self.tableViewOutlet.reloadData()

				case .failure(let loadingError):
					self.errorView.isHidden = false
					self.errorLabel.text = loadingError.description + "\n\n Tap to retry"

				}
			}
		}.store(in: &subscriptions)
	}

	@IBAction func onErrorViewPressed(_ sender: Any) {
		self.errorView.isHidden = true
		viewModel.loadEndPointData()
	}

}



extension ViewController : UITableViewDelegate , UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.filtereditems.count
	}
	public func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as? HomeCell else {return UITableViewCell()}
		let item = filtereditems[indexPath.row]
		cell.setCellDetails(title: item.title, description: item.itemDescription)

		imageCollectionLoader.requestImage(requestDate: Date(), url: item.imageURL, indexPath: indexPath, tag: "card", successHandler: {
			image , index , date in
			guard let visibleCell = tableView.cellForRow(at: index) as? HomeCell else {return}
			visibleCell.setImage(image: image, parentTableView: tableView)
		}, failedHandler: {
			_,_,_ in


		})


		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = filtereditems[indexPath.row]
		EmailService.shared.sendEmail(subject: item.title, body: item.itemDescription, to: "ohassan443@gmail.com", completion: {
			sent in
		})
	}


}
extension ViewController : UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		self.searchText = searchText
		tableViewOutlet.reloadData()
	}
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}

}
