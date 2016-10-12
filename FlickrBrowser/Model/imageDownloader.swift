import UIKit

class ImageDownloader {
	var image: UIImage!

	init() {
		image = nil
	}
	
	func getImage(source: String) -> UIImage {
		if let requestURL = NSURL(string: source) {
			let session = NSURLSession.sharedSession()
			print("\(requestURL)")
			let task = session.dataTaskWithURL(requestURL) {
				(data, response, error) -> Void in
				
				if error == nil {
					print("error = \(error)")
					
					let httpResponse = response as! NSHTTPURLResponse
					let statusCode = httpResponse.statusCode
					print(statusCode)
					if (statusCode == 200) {
						if let image = UIImage(data: data!) {
							print(image.size)
							self.image = image
						}
					}
				}
			}
			task.resume()
		}
		return image
	}
}
