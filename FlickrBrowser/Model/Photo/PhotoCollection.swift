//
//  PhotoCollection.swift
//  FlickrBrowser
//
//  Created by maxlev on 10/2/16.
//  Copyright © 2016 LokiSoftware. All rights reserved.
//

import Foundation

class PhotoCollection {
	var photos: [Photo] = []
	
	func addPhoto(photo: Photo) {
		photos.append(photo)
	}
	
	func getSize() -> Int {
		return photos.count
	}
	
	func printCollection() {
		print("================================== PHOTO COLLECTION INFORMATION ===============================================")
		print("There are \(photos.count) photos in the collection.")
		for item in photos {
			print(item)
		}
		print("===============================================================================================================")
	}
}
