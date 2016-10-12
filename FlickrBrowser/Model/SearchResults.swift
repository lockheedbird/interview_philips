import Foundation

class SearchResultsJsonObject {
	var photoCollection = PhotoCollection()
	
	func addPhotosToCollection(data: NSData, startingAtRow: Int) {
		do{
			let json = try NSJSONSerialization.JSONObjectWithData(data, options:.AllowFragments)

			if let photosInfo = json["photos"] as? [String: AnyObject] {
				if let photos = photosInfo["photo"] as? [[String : AnyObject]] {
					var row: Int = startingAtRow
					for photo in photos {
						if let owner = photo["owner"] as? String {
							if let id = photo["id"] as? String {
								if let title = photo["title"] as? String {
									photoCollection.addPhoto(row, photo: Photo(id: id, owner: owner, title: title))
								}
							}
						}
						row += 1
					}
				}
				
			}
		}
		catch {
			print("Error with Json: \(error)")
		}
		print("Completed Initializing Photo Collection")		
	}
	
	func getPhotoCollection() -> PhotoCollection {
		return photoCollection
	}
}
