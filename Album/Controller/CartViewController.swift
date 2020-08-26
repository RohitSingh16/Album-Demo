//
//  CartViewController.swift
//  Album
//
//  Created by Rohit Kumar on 25/08/20.
//  Copyright © 2020 Rohit Kumar. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cartListTable: UITableView!

    var cartList: [Album] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        cartListTable.delegate = self
        cartListTable.dataSource = self
        cartListTable.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartListTable.dequeueReusableCell(withIdentifier: "AlbumTableViewCell", for: indexPath) as! AlbumTableViewCell
        let albumInfo: Album = cartList[indexPath.row]
        cell.artistNCollectionInfoLabel.text = "\(albumInfo.artistName) - \(albumInfo.collectionName)"
        cell.collectionNameLabel.text = "\(albumInfo.trackName)"
        cell.releaseDateLabel.text = Utils.dateFormater(date: albumInfo.releaseDate)
        cell.priceLabel.text = "$\(albumInfo.collectionPrice)"
        cell.trackImage.loadImage(urlString: albumInfo.artworkUrl100)
        return cell
    }
}
