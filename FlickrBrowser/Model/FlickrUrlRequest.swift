import Foundation

class FlickrUrlRequest {
	var responseData: NSData? = nil
	var requestURL: NSURL? = nil
	
	func fetchResponseData(source: String, callback: (AnyObject) -> ()) {
		requestURL = NSURL(string: source)!
		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithURL(requestURL!) {
			(data, response, error) -> Void in
			if error == nil {
				let httpResponse = response as! NSHTTPURLResponse
				let statusCode = httpResponse.statusCode
				if (statusCode == 200) {
					callback(data!)
				}
			}
		}
		task.resume()
	}
	
	func getResponseData() -> NSData {
		return responseData!
	}
	
	func setResponseData(data: NSData) {
		responseData = data
	}
	
	func printData() {
		print(responseData)
	}
}
