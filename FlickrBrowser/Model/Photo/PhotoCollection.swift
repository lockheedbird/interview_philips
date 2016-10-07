//
//  PhotoCollection.swift
//  FlickrBrowser
//
//  Created by maxlev on 10/2/16.
//  Copyright © 2016 LokiSoftware. All rights reserved.
//

import Foundation
import UIKit

class PhotoCollection {
	var photoDictionaryByRow: [Int: Photo] = [:]
	
	func addPhoto(index: Int, photo: Photo) {
		photoDictionaryByRow[index] = photo
	}
	
	func getSize() -> Int {
		return photoDictionaryByRow.count
	}
	
	func setPhotoByIndex(index: Int, image: UIImage) {
		photoDictionaryByRow[index]!.setImage(image)
	}
	
	func getPhotoByIndex(index: Int) -> UIImage? {
		return photoDictionaryByRow[index]!.getImage()
	}

	
	func printCollection() {
		print("================================== PHOTO COLLECTION INFORMATION ===============================================")
		print("There are \(photoDictionaryByRow.keys.count) photos in the collection.")
		for item in photoDictionaryByRow {
			print(item)
		}
		print("===============================================================================================================")
	}
}
