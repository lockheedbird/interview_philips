import UIKit

class SingleImageJsonObject {
	var imageData:[[String : AnyObject]] = []
	
	func singleImage(responseData: NSData) {
		let json = try! NSJSONSerialization.JSONObjectWithData(responseData, options:.AllowFragments)
		if let sizesInfo = json["sizes"] as? [String: AnyObject] {
			if let sizes = sizesInfo["size"] as?  [[String : AnyObject]] {
				imageData = sizes
			}
		}
	}
	
	func getImageSourceByLabel(label: String = "Square") -> String? {
		for item in imageData {
			if let image = item as NSDictionary? {
				let key = image["label"] as? String
				if key == label {
					return image["source"] as? String
				}
			}
		}
		return nil
	}
}
