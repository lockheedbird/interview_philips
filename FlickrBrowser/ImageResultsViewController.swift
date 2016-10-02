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
	var searchResults = SearchResults()
	var photoCollection = PhotoCollection()
	
	var tableSize: Int = 0
	var photoDictionaryByRow: [Int: UIImage] = [:]  //Refactor into a data structure
	
	var selectedImage: UIImage? = nil
	
	var imageContainer = ImageContainer()
	
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
				print(self.flickrPhotoSearch.printData())
			}
			
			self.searchResults.addPhotosToCollection(self.flickrPhotoSearch.getResponseData())
			self.photoCollection = self.searchResults.getPhotoCollection()
			
			
			dispatch_async(dispatch_get_main_queue()) {
				self.displayPhotosInTable()
			}
			
		})
		
		// Enable search bar after search is done
		self.searchBar.userInteractionEnabled = true
	}
	
	private func displayPhotosInTable()
	{
		tableSize = photoCollection.getSize()
		tableView.reloadData()
		
		var row: Int = 0
		for item in photoCollection.photos {
			self.downloadSizes(item.id, row: row)
			row += 1
		}
	}
	
	func photosDataBasedOnSearchTerm1(searchTerm: String) {
		photoDictionaryByRow.removeAll()
		tableSize = 0
		tableView.reloadData()
		
		if let requestURL = NSURL(string: FlickrSearchRequestString(searchTerm: searchTerm).buildRequest()) {
			let session = NSURLSession.sharedSession()
			print("\(requestURL)")
			let task = session.dataTaskWithURL(requestURL) {
				(data, response, error) -> Void in
				
				print("error = \(error)")
				
				let httpResponse = response as! NSHTTPURLResponse
				let statusCode = httpResponse.statusCode
				print(statusCode)
				if (statusCode == 200) {
					print("Everyone is fine, file downloaded successfully.")
					
					do{
						
						let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
						
						if let photosInfo = json["photos"] as? [String: AnyObject] {
							if let photos = photosInfo["photo"] as?  [[String : AnyObject]] {
								self.tableSize = photos.count
								dispatch_async(dispatch_get_main_queue()) {
									self.tableView.reloadData()
								}
								var row: Int = 0
								for photo in photos {
									if let owner = photo["owner"] as? String {
										if let id = photo["id"] as? String {
											self.downloadSizes(id, row: row)
											print(owner,id)
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
				}
			}
			print("task.resume")
			task.resume()
		}
	}
	
	
	func downloadImageData(source: String, row: Int) {
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
							self.photoDictionaryByRow[row] = image
							if (self.photoDictionaryByRow.count == self.tableSize) {
								dispatch_async(dispatch_get_main_queue()) {
									self.searchBar.userInteractionEnabled = true
								}
							}
							dispatch_async(dispatch_get_main_queue()) {
								self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 0)], withRowAnimation:.Automatic)
							}
						}
					}
				}
			}
			task.resume()
		}
	}
	
	func downloadSizes(photoID: String, row: Int) {
		if let requestURL = NSURL(string: FlickrGetSizesRequestString(photoID: photoID).buildRequest()) {
			print("Download sizes request URL: \(requestURL)")
			let session = NSURLSession.sharedSession()
			let task = session.dataTaskWithURL(requestURL) {
				(data, response, error) -> Void in
				if error == nil {
					let httpResponse = response as! NSHTTPURLResponse
					let statusCode = httpResponse.statusCode
					if (statusCode == 200) {
						let json = try! NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
//						if let imageData = json["sizes"] as? [String: AnyObject] {
//							let tmpImage = SingleImageData(imageData: imageData)
//							tmpImage.printImageData()
//							print("---------------------------------------------")
//							print(tmpImage.imageSourceByLabel("Original"))
//							print("---------------------------------------------")
//							self.imageContainer.addImage(row, image: tmpImage)
//						}
						
						if let sizesInfo = json["sizes"] as? [String: AnyObject] {
							if let sizes = sizesInfo["size"] as?  [[String : AnyObject]] {
								if let size = sizes.first {
									if let source = size["source"] as? String {
										print("image source: \(source)")
										
										self.downloadImageData(source, row: row)
									}
								}
							}
						}
					}
				}
			}
			task.resume()
		}
	}
}

extension ImageResultsViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableSize
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ImageResultTableViewCell
		
		if let image = photoDictionaryByRow[indexPath.row] {
			cell.imageView?.image = image
		}
		cell.textLabel?.text = "Row \(indexPath.row)"
		
		return cell
	}
}

extension ImageResultsViewController: UITableViewDelegate {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedImage = photoDictionaryByRow[indexPath.row]
		
		performSegueWithIdentifier("ShowImage", sender: self)
	}
}

extension ImageResultsViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		print("Searched for: \(searchBar.text)")
		searchBar.userInteractionEnabled = false
		if let searchTerm = searchBar.text {
			photosDataBasedOnSearchTerm(searchTerm)
		}
		searchBar.endEditing(true)
	}
}
