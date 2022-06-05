	//
	//  ImageLoader.swift
	//  NOUSAPP
	//
	//  Created by Omar Hassan  on 30/05/2022.
	//

import Combine
import Foundation
import UIKit
import ImageCollectionLoader
import SwiftUI


struct CustomImageView: View {
	var urlString: String
	@ObservedObject var imageLoader = ImageLoaderService()
	@State var image: UIImage? = nil
	var defaultImage = UIImage()
	@State var loadedImageSize : CGSize? = nil

	var body: some View {


		Image(uiImage: image ?? defaultImage)
			.resizable()
			.aspectRatio(contentMode: .fit)

			.onReceive(imageLoader.$image) { loadedImage in
				guard loadedImage != nil else{return}
				self.loadedImageSize = loadedImage?.size
				self.image = loadedImage!

			}
			.onAppear {
				imageLoader.loadImage(for: urlString)
			}.frame(width: UIScreen.main.bounds.width)/* loadedImageSize == nil ?  : geometry.size.width * loadedImageSize!.height / loadedImageSize!.width )*/


	}
}


class ImageLoaderService: ObservableObject {
	@Published var image: UIImage? = nil
	var size : CGSize? = nil
	let imageLoader = ImageLoaderBuilder().concrete(ramMaxItemsCount: 40)

	func loadImage(for urlString: String) {
		guard let _ = URL(string: urlString) else { return }

		imageLoader.getImageFrom(urlString: urlString, completion: {[weak self] loadedImage  in
			guard let self = self else{return}
			DispatchQueue.main.async {
				self.image = loadedImage
				self.size = CGSize(width: loadedImage.size.width, height: loadedImage.size.height)
			}
		}, fail: {_,_ in
			print("failed @ \(urlString)")
		})



	}

}
