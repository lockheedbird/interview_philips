import Foundation
import UIKit

class Photo {
	var id: String
	var owner: String
	var title: String
	var image: UIImage?
	var thumbNail: UIImage?
	
	init(id: String, owner: String, title: String) {
		self.id = id
		self.owner = owner
		self.title = title
		self.thumbNail = nil
		self.image = nil
	}
	
	
	func setThumbnail(thumbNail: UIImage) {
		self.thumbNail = thumbNail
	}

	func setImage(image: UIImage) {
		self.image = image
	}
	
	func getThumbnail() -> UIImage? {
		return thumbNail
	}
	
	func getImage() -> UIImage? {
		return image
	}
}

extension Photo: CustomStringConvertible {
	var description: String {
		return "(Photo info: id = \(id), owner = \(owner), title = \(title), image = \(thumbNail), image = \(image))" +
			" Photo URL: https://www.flickr.com/photos/\(owner)/\(id)"
	}
}
