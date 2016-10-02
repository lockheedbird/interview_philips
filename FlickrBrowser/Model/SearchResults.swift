//
//  SearchResults.swift
//  FlickrBrowser
//
//  Created by maxlev on 10/2/16.
//  Copyright © 2016 LokiSoftware. All rights reserved.
//

import Foundation


class SearchResults {
	var photoCollection = PhotoCollection()
	
	func addPhotosToCollection(data: NSData) {
		do{
			let json = try NSJSONSerialization.JSONObjectWithData(data, options:.AllowFragments)

			if let photosInfo = json["photos"] as? [String: AnyObject] {
				if let photos = photosInfo["photo"] as? [[String : AnyObject]] {
					var row: Int = 0
					for photo in photos {
						if let owner = photo["owner"] as? String {
							if let id = photo["id"] as? String {
								if let title = photo["title"] as? String {
									photoCollection.addPhoto(Photo(id: id, owner: owner, title: title))
								}
							}
						}
						row = row + 1
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






