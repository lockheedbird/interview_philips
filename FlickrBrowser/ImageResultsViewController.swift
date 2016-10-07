//
//  ImageResultsViewController.swift
//  FlickrBrowser
//
//  Created by maxlev on 9/11/16.
//  Copyright © 2016 LokiSoftware. All rights reserved.
//

import UIKit

class ImageResultsViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	var flickrPhotoSearch = FlickrUrlRequest()
	var downloadSizes = FlickrUrlRequest()
	var uiImageData = FlickrUrlRequest()
	
	var searchResults = SearchResultsJsonObject()
	var photoCollection = PhotoCollection()
	var jsonImageData = SingleImageJsonObject()
	
	var tableSize: Int = 0
	var photoDictionaryByRow: [Int: UIImage] = [:]  //Refactor into a data structure
	
	var selectedImage: UIImage? = nil
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ShowImage" {
			if let imageViewController = segue.destinationViewController as? ImageViewController {
				imageViewController.image = selectedImage
			}
		}
	}

	func photosDataBasedOnSearchTerm(searchTerm: String) {
		flickrPhotoSearch.fetchResponseData(FlickrSearchRequestString(searchTerm: searchTerm).buildRequest(), callback: { (response) in
			if let responseData = response as? NSData {
				self.flickrPhotoSearch.setResponseData(responseData)
				//print(self.flickrPhotoSearch.printData())
			}
			
			// Every new search inquery needs to start updating table at row 0
			// Scrolling to the bottom of the table should start append to search results instead so it has to start
			// with self.photoCollection.getSize()
			self.searchResults.addPhotosToCollection(self.flickrPhotoSearch.getResponseData(), startingAtRow: 0)
			self.photoCollection = self.searchResults.getPhotoCollection()
			
			self.downloadImageForEverySearchResult()
			
			// Enable search bar after search is done
			//dispatch_async(dispatch_get_main_queue()) {
				//self.searchBar.userInteractionEnabled = true
				//self.updateTableView()
			//}
		})
		// TODO: Figure out how to stop scrolling to the top of the table after viewing the picture
		// TODO: Figure out how to display table content after every query
		self.searchBar.userInteractionEnabled = true
		self.updateTableView()
	}

	private func updateTableView() {
		self.tableSize = self.photoCollection.getSize()
		self.tableView.reloadData()
	}

	private func downloadImageForEverySearchResult()
	{
		var row: Int = 0
		for key in photoCollection.photoDictionaryByRow.keys {
			self.downloadSizes(photoCollection.photoDictionaryByRow[key]!.id, row: row, photo: photoCollection.photoDictionaryByRow[key]!)
			row += 1
		}
	}
	
	func downloadSizes(photoID: String, row: Int, photo: Photo) {
		downloadSizes.fetchResponseData(FlickrGetSizesRequestString(photoID: photoID).buildRequest(), callback: { (response) in
			if let responseData = response as? NSData {
				self.jsonImageData.singleImage(responseData)
				if let imageSource = self.jsonImageData.getImageSourceByLabel() {
					print("Image Source: \(imageSource)")
					self.downloadImageData(imageSource, row: row, photo: photo)
				}
			}
		})
	}
	
	func downloadImageData(source: String, row: Int, photo: Photo) {
		uiImageData.fetchResponseData(source, callback: { (response) in
			if let responseData = response as? NSData {
				self.uiImageData.setResponseData(responseData)
				if let image = UIImage(data: self.uiImageData.getResponseData()) {
					print("Downloaded image \(row)")
					print(image)
					photo.setImage(image)
					self.photoCollection.addPhoto(row, photo: photo)
					
					self.photoDictionaryByRow[row] = image
//					if (self.photoDictionaryByRow.count == self.tableSize) {
//						dispatch_async(dispatch_get_main_queue()) {
//							self.searchBar.userInteractionEnabled = true
//						}
//					}
//					dispatch_async(dispatch_get_main_queue()) {
//						self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 0)], withRowAnimation:.Automatic)
//					}
				}
			}
		})
	}
}

extension ImageResultsViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableSize
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ImageResultTableViewCell
		
		//if let image = photoDictionaryByRow[indexPath.row] {
		if let image = self.photoCollection.getPhotoByIndex(indexPath.row) {
			cell.imageView?.image = image
		}
		//cell.textLabel?.text = "Row \(indexPath.row)"
		cell.textLabel?.text = "Row \(indexPath.row + 1) \(self.photoCollection.photoDictionaryByRow[indexPath.row]!.title)"
		
		return cell
	}
}

extension ImageResultsViewController: UITableViewDelegate {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		//selectedImage = photoDictionaryByRow[indexPath.row]
		selectedImage = self.photoCollection.getPhotoByIndex(indexPath.row)

		performSegueWithIdentifier("ShowImage", sender: self)
	}
}

extension ImageResultsViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let indexes = tableView.indexPathsForVisibleRows;
		for index in indexes! {
			if (photoCollection.getSize() - index.row < 10) {
				print("Index path: \(index.row)");
				if let searchTerm = searchBar.text {
					photosDataBasedOnSearchTerm(searchTerm)
				}
			}
		}
	}
}

extension ImageResultsViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		//print("Searched for: \(searchBar.text)")
		searchBar.userInteractionEnabled = false
		if let searchTerm = searchBar.text {
			photosDataBasedOnSearchTerm(searchTerm)
		}
		// Disable search bar after search is initiated
		searchBar.endEditing(true)
	}
}
