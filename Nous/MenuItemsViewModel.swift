	//
	//  ViewModel.swift
	//  NOUSAPP
	//
	//  Created by Omar Hassan  on 29/05/2022.
	//
import Combine
import Foundation
import ImageCollectionLoader
	///
public enum urlLoadingError: Error {

	case failedUrlParsing
	case nilData
	case accessedDataBeforeLoading
	case failedParsingResponse
	case networkError(description:String, error:Error?)

	var description : String {
		switch self {
		case .failedUrlParsing :
			return "Failed parsing url"
		case .nilData :
			return "Invalid response"
		case .accessedDataBeforeLoading :
			return "Invalid setup"
		case .failedParsingResponse :
			return "Failed parsing server response"
		case .networkError(_,_) :
			return "Somethign went wrong, please try again later"
		}
	}

}
public enum LoaddingItem<T> {
	case currentlyLoading
	case loaded(result:T)
	case accessedDataBeforeLoading
}

class MenuItemsViewModel :ObservableObject{

	@Published private(set) var menuItems : LoaddingItem<Result<[MenuItem],urlLoadingError>> = .accessedDataBeforeLoading


	private var menuItemsRepo : MenuItemsRepoProtocol
	init(menuItemsRepo: MenuItemsRepoProtocol) {
		self.menuItemsRepo = menuItemsRepo
	}

	func loadEndPointData(){
		switch menuItems {
		case .currentlyLoading : return
		case .accessedDataBeforeLoading , .loaded(result: _):


			menuItems = .currentlyLoading
			menuItemsRepo.loadData( onComplete: {[weak self]
				response in
				guard let self = self else{return}
				DispatchQueue.main.async {
					switch response{
					case .success(items: let loadedItems):
						self.menuItems = .loaded(result: .success(loadedItems))

					case .onFail(error: let loadingError):
						self.menuItems = .loaded(result: .failure(loadingError))


					}
				}
			})
		}



	}
}
