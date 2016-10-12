class FlickrRequestStringBuilder {
	let urlHeader:    String  = "https://api.flickr.com/services/rest/?"
	let api_key:      String  = "api_key=c754e354bae8187babe94a1715e047ae"
	let urlSuffix:    String  = "format=json&nojsoncallback=1"
	let urlSeparator: String  = "&"
	var api_call:     String  = "method="
	
	func buildRequest() -> String {
		return ""
	}
}

class FlickrSearchRequestString : FlickrRequestStringBuilder {
	var searchTerm: String = "text="
	
	init(searchTerm: String) {
		super.init()
		self.api_call += "flickr.photos.search"
		self.searchTerm += searchTerm
	}
	
	override func buildRequest() -> String {
		searchTerm = searchTerm.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
		
		let urlString = urlHeader + api_call + urlSeparator + api_key + urlSeparator + searchTerm + urlSeparator + urlSuffix
		
		return urlString
	}
}

class FlickrGetSizesRequestString : FlickrRequestStringBuilder {
	var photoID: String = "photo_id="
	
	init(photoID: String) {
		super.init()
		self.api_call += "flickr.photos.getSizes"
		self.photoID += photoID
	}
	
	override func buildRequest() -> String {
		photoID = photoID.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
		
		let urlString = urlHeader + api_call + urlSeparator + api_key + urlSeparator + photoID + urlSeparator + urlSuffix
		
		return urlString
	}
}










