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
	
	var currentSearchTerm: String = ""
	var isNewSearchTerm: Bool = true
	var shouldLoadMoreImages: Bool = false
	var tableSize: Int = 0
	
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
			}

			var bottomTableRow = self.photoCollection.getSize()
			if (self.isNewSearchTerm) {
				bottomTableRow = 0
				self.photoCollection.resetCollection()
			}
			
			self.searchResults.addPhotosToCollection(self.flickrPhotoSearch.getResponseData(), startingAtRow: bottomTableRow)
			self.photoCollection = self.searchResults.getPhotoCollection()
			self.tableSize = self.photoCollection.getSize()
			dispatch_async(dispatch_get_main_queue()) {
				self.tableView.reloadData()
				self.searchBar.userInteractionEnabled = true
			}
			
			self.downloadImageForEverySearchResult()
			self.shouldLoadMoreImages = true
		})
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
					self.downloadImageData(imageSource, row: row, photo: photo, isThumbnail: true)
				}
				if let imageSource = self.jsonImageData.getImageSourceByLabel("Large") {
					self.downloadImageData(imageSource, row: row, photo: photo)
				}
			}
		})
	}
	
	func downloadImageData(source: String, row: Int, photo: Photo, isThumbnail: Bool = false) {
		uiImageData.fetchResponseData(source, callback: { (response) in
			if let responseData = response as? NSData {
				self.uiImageData.setResponseData(responseData)
				if let image = UIImage(data: self.uiImageData.getResponseData()) {
					if(isThumbnail) {
						photo.setThumbnail(image)
					}
					else {
						photo.setImage(image)
					}
					
					self.photoCollection.addPhoto(row, photo: photo)
					dispatch_async(dispatch_get_main_queue()) {
						self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 0)], withRowAnimation:.Automatic)
					}
				}
			}
		})
	}
}

extension ImageResultsViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("Table Size \(tableSize)")
		return tableSize
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ImageResultTableViewCell
		
		if let image = self.photoCollection.getThumbnailByIndex(indexPath.row) {
			cell.imageView?.image = image
		}
		cell.textLabel?.text = "Row \(indexPath.row + 1): Title: \(self.photoCollection.photoDictionaryByRow[indexPath.row]!.title)"
		
		return cell
	}
}

extension ImageResultsViewController: UITableViewDelegate {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.searchBar.endEditing(true)
		selectedImage = self.photoCollection.getPhotoByIndex(indexPath.row)

		performSegueWithIdentifier("ShowImage", sender:self)
	}

	func scrollViewDidScroll(scrollView: UIScrollView) {
		let indexes = tableView.indexPathsForVisibleRows;
		for index in indexes! {
			if (photoCollection.getSize() - index.row < 10 && self.shouldLoadMoreImages) {
				print("Index path: \(index.row)");
				self.shouldLoadMoreImages = false
				self.searchBarSearchButtonClicked(searchBar)
			}
		}
	}
}

extension ImageResultsViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		print("Searched for: \(searchBar.text)")
		print("Current Search Term: \(self.currentSearchTerm)")
		
		searchBar.userInteractionEnabled = false
		if let searchTerm = searchBar.text {
			photosDataBasedOnSearchTerm(searchTerm)
			if (self.currentSearchTerm != searchTerm) {
				self.isNewSearchTerm = true
				self.currentSearchTerm = searchTerm
			}
			else
			{
				self.isNewSearchTerm = false
			}
		}
		searchBar.endEditing(true)
	}
}
