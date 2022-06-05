	//
	//  HomeCell.swift
	//  Nous
	//
	//  Created by Omar Hassan  on 05/06/2022.
	//

import Foundation
import UIKit
class HomeCell : UITableViewCell {


	@IBOutlet weak var imageViewOutlet: UIImageView!
	@IBOutlet weak var imageViewActivityIndicator: UIActivityIndicatorView!

	@IBOutlet weak var titleLabel: UILabel!

	@IBOutlet weak var descriptionLabel: UILabel!


	override func prepareForReuse() {
		
		imageViewActivityIndicator.startAnimating()
		titleLabel.text = ""
		descriptionLabel.text = ""
	}
	func setCellDetails(title : String,description :String){
		titleLabel.text = title
		descriptionLabel.text = description
	}
	func setImage(image:UIImage?,parentTableView : UITableView){
		image == nil ? imageViewActivityIndicator.startAnimating() : imageViewActivityIndicator.stopAnimating()
		imageViewOutlet.image = image
		/*guard let size = image?.size else{return}
		let aspectRation =  size.height / size.width
		parentTableView.beginUpdates()
		imageViewHeightConstraint.constant = self.frame.width * aspectRation
		parentTableView.endUpdates()*/
		
	}

}
