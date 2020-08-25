//
//  MainViewController.swift
//  Album
//
//  Created by Rohit Kumar on 24/08/20.
//  Copyright © 2020 Rohit Kumar. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {
    
    @IBOutlet weak var albumTable: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var picker  = UIPickerView()
    
    var albumViewModel = AlbumViewModel()
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        albumTable.allowsMultipleSelection = true
        
        let sort = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortAlbums))
        let cart = UIBarButtonItem(title: "Cart", style: .plain, target: self, action: #selector(goToCart))

        navigationItem.rightBarButtonItems = [cart, sort]
        
        albumViewModel.fetchAlbums(){ [weak self] (albums) in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if let rows = albumTable.indexPathsForVisibleRows {
            for row in rows {
                albumTable.deselectRow(at: row, animated: false)
            }
        }
        albumViewModel.selectedAlbums.removeAll()
    }
    
    func updateUI() {
        self.albumTable.delegate = self
        self.albumTable.dataSource = self
        self.albumTable.reloadData()
    }
    
     // MARK:- Search
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    func filterContentForSearchText(_ searchText: String) {
        albumViewModel.searchedAlbums = albumViewModel.albums.filter { (album: Album) -> Bool in
            return album.trackName.lowercased().contains(searchText.lowercased()) || album.artistName.lowercased().contains(searchText.lowercased()) || album.collectionName.lowercased().contains(searchText.lowercased())
        }
        albumTable.reloadData()
    }
    
    // MARK:- Bar buttons actions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! CartViewController
        destination.cartList = albumViewModel.selectedAlbums.map({
            albumViewModel.albums[$0]
        })
    }
    @objc func goToCart(){
        performSegue(withIdentifier: "cartSegue", sender: self)
    }
    
    @objc func sortAlbums(){
        albumTable.reloadData()
        albumViewModel.selectedAlbums.removeAll()
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.lightGray
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 216, width: UIScreen.main.bounds.size.width, height: 216)
        self.view.addSubview(picker)
    }
}

extension AlbumViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        albumViewModel.selectedAlbums.append(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        albumViewModel.selectedAlbums = albumViewModel.selectedAlbums.filter({
            $0 != indexPath.row
        })
    }
}

extension AlbumViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return albumViewModel.searchedAlbums.count
        }
        return albumViewModel.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumTable.dequeueReusableCell(withIdentifier: "AlbumTableViewCell", for: indexPath) as! AlbumTableViewCell
        let albumInfo: Album
        if isFiltering {
            albumInfo = albumViewModel.searchedAlbums[indexPath.row]
         } else {
           albumInfo = albumViewModel.albums[indexPath.row]
        }
        cell.artistNCollectionInfoLabel.text = "\(albumInfo.artistName) - \(albumInfo.trackName)"
        cell.collectionNameLabel.text = "\(albumInfo.collectionName)"
        cell.releaseDateLabel.text = Utils.dateFormater(date: albumInfo.releaseDate)
        cell.priceLabel.text = "$\(albumInfo.collectionPrice)"
        cell.trackImage.loadImage(urlString: albumInfo.artworkUrl100)
        return cell
    }
    
}

extension AlbumViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            albumViewModel.sortedByArtist()
            albumTable.reloadData()
        case 1:
            albumViewModel.sortedByCollection()
            albumTable.reloadData()
        case 2:
            albumViewModel.sortedByCollectionPrice()
            albumTable.reloadData()
        case 3:
            albumViewModel.sortedByTrackName()
            albumTable.reloadData()
        default:
            albumTable.reloadData()
        }
        self.picker.removeFromSuperview()
    }

}

extension AlbumViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        albumViewModel.sortList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        albumViewModel.sortList[row]
    }
}

extension AlbumViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

