//
//  Photo.swift
//  FlickrBrowser
//
//  Created by maxlev on 10/2/16.
//  Copyright © 2016 LokiSoftware. All rights reserved.
//

import Foundation
import UIKit

class Photo {
	var id: String
	var owner: String
	var title: String
	var image: UIImage?
	
	init(id: String, owner: String, title: String) {
		self.id = id
		self.owner = owner
		self.title = title
		self.image = nil
	}
	
	func setImage(image: UIImage) {
		self.image = image
	}
	
	func getImage() -> UIImage? {
		return image
	}
}

extension Photo: CustomStringConvertible {
	var description: String {
		return "(Photo info: id = \(id), owner = \(owner), title = \(title), image = \(image))" +
			" Photo URL: https://www.flickr.com/photos/\(owner)/\(id)"
	}
}
