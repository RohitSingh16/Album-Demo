//
//  AlbumViewModel.swift
//  Album
//
//  Created by Rohit Kumar on 25/08/20.
//  Copyright © 2020 Rohit Kumar. All rights reserved.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

class AlbumViewModel
{
    
    init(model: [Album]? = nil) {
        if let inputModel = model {
            albums = inputModel
        }
    }
    var sortList = ["Artist Name","Collection Name", "Collection Price", "Track Name"]
    var albums = [Album]()
    var selectedAlbums = [Int]()
    var searchedAlbums: [Album] = []
    
    func sortedByArtist(){
        return albums.sort{
            $0.artistName.lowercased() > $1.artistName.lowercased()
        }
    }
    
    func sortedByCollection(){
        return albums.sort{
            $0.collectionName.lowercased() > $1.collectionName.lowercased()
        }
    }
    
    func sortedByTrackName(){
        return albums.sort{
            $0.trackName.lowercased() > $1.trackName.lowercased()
        }
    }
    
    func sortedByCollectionPrice(){
        return albums.sort{
            $0.collectionPrice > $1.collectionPrice
        }
    }
    
}

extension AlbumViewModel{
    func fetchAlbums(completionHandler: @escaping ([Album]) -> Void){
        let defaults = UserDefaults.standard
        if Utils.Connection(){
            let url = URL(string: "https://itunes.apple.com/search?term=all")!
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                      error == nil else {
                      print(error?.localizedDescription ?? "Response Error")
                      return }
                do{
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                                           dataResponse, options: [])
                    var albumList: [Album] = []
                    guard let jsonDict = jsonResponse as? [String: Any] else { return }
                    guard let albumArray = jsonDict["results"] as? [[String: Any]] else { return }
                    for album in albumArray{
                        albumList.append(Album(album))
                    }
                    var finalList = albumList.enumerated()
                        .filter { (index, albumDict) in !albumList[0..<index].contains(where: {$0.trackName == albumDict.trackName}) }
                    .map { $1 }
                    finalList.sort{
                        $0.collectionPrice > $1.collectionPrice
                    }
                    self.albums = finalList
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(finalList) {
                        defaults.set(encoded, forKey: "SavedAlbums")
                    }
                    completionHandler(finalList)
                 } catch let parsingError {
                    print("Error", parsingError)
               }
            }
            task.resume()
        }else{
            if let savedAlbum = defaults.object(forKey: "SavedAlbums") as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode([Album].self, from: savedAlbum) {
                    self.albums = loadedPerson
                    completionHandler(loadedPerson)
                }
            }
        }
    }
}

extension UIImageView {

    func loadImage(urlString: String) {
        
        if let cacheImage = imageCache.object(forKey: (urlString as AnyObject) as! NSString) {
            self.image = cacheImage as? UIImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Couldn't download image: ", error)
                return
            }
            
            guard let data = data else { return }
            let image = UIImage(data: data)
            imageCache.setObject(image!, forKey: (urlString as AnyObject) as! NSString)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()

    }
}
