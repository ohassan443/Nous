	//
	//  MenuItemsRepo.swift
	//  NOUSAPP
	//
	//  Created by Omar Hassan  on 04/06/2022.
	//

import Foundation



class MenuItemsRepo : MenuItemsRepoProtocol{
	func loadData( onComplete: @escaping (MenuItemsReturnResponse) -> Void) {

		guard let url = URL(string: Constants.menuItemsUrls) else {
			onComplete(.onFail(error: urlLoadingError.failedUrlParsing))
				//print("could not create url from: \(webAddress)")
			return
		}

		let urlRequest = URLRequest(url: url)
		let config = URLSessionConfiguration.default
		config.requestCachePolicy = .reloadIgnoringLocalCacheData

		URLSession.shared.dataTask(with: urlRequest, completionHandler: {
			[weak self] data,response , error in

			guard let _ = self else {
				return
			}
			guard error == nil else {
				onComplete(.onFail(error:urlLoadingError.networkError(description: "",error:error)))

				return
			}
			guard let responseData = data  else {
				onComplete(.onFail(error:urlLoadingError.nilData))
				return
			}
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode ,statusCode == 200 else {
				onComplete(.onFail(error:urlLoadingError.networkError(description: "invalid response",error:error)))
				return
			}

			do {
				let itemsWrapper = try JSONDecoder().decode(MenuItemsWrapper.self, from: responseData)
				onComplete(.success(items: itemsWrapper.items))
			} catch {
				onComplete(.onFail(error:urlLoadingError.failedParsingResponse))

			}
		}).resume()
	}
}
