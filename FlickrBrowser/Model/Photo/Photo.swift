//
//  Photo.swift
//  FlickrBrowser
//
//  Created by maxlev on 10/2/16.
//  Copyright © 2016 LokiSoftware. All rights reserved.
//

import Foundation


class Photo {
	var id: String
	var owner: String
	var title: String
	
	init(id: String, owner: String, title: String) {
		self.id = id
		self.owner = owner
		self.title = title
	}
}

extension Photo: CustomStringConvertible {
	var description: String {
		return "(Photo info: id = \(id), owner = \(owner), title = \(title))"
	}
}
