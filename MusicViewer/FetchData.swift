//
//  FetchData.swift
//  MusicViewer
//
//  Created by Kazim Walji on 5/21/21.
//

import Foundation
import UIKit

struct AllData: Decodable {
    let feed: FeedDict
}
struct FeedDict: Decodable {
    let results: [AlbumCodable]
}
struct AlbumCodable: Decodable {
    var name: String
    var artistName: String
    let releaseDate: String
    let artworkUrl100: String
    let copyright: String
    let genres: [Genre]
    let id: String
}
struct Genre: Decodable {
    let name: String
}
struct Album: Hashable {
    let name: String
    let artistName: String
    let releaseDate: String
    let copyright: String
    let genre: String
    var image: UIImage
    let id: String
    
    init(name: String, artistName: String, releaseDate: String, copy: String, firstGenre: String, ID: String) {
        self.name = name
        self.artistName = artistName
        self.releaseDate = releaseDate
        self.copyright = copy
        self.genre = firstGenre
        self.id = ID
        self.image = UIImage()
    }
    
    mutating func stringToImage(url: String) {
        var finalimage = UIImage()
        if let url = URL(string: url) {
            if let data = try? Data(contentsOf: url)
            {
                finalimage = UIImage(data: data) ?? UIImage()
            }
        }
        self.image = finalimage
    }
    
}

struct FetchData {
    static func getAlbums(urlString: String) -> [Album]? {
        do {
            if let url = URL(string: urlString) {
                print("Data unavailable")
                let data = try Data(contentsOf: url)
                let allData = try JSONDecoder().decode(AllData.self, from: data)
                let feed = allData.feed.results
                return convertToHashable(feed: feed)
            }
        }
        catch {
            print("data unavailable")
        }
        return nil
    }
    
    static func convertToHashable(feed: [AlbumCodable]) -> [Album] {
        var newFeed = [Album]()
        for album in feed {
            var newAlbum = Album(name: album.name, artistName: album.artistName, releaseDate: album.releaseDate, copy: album.copyright, firstGenre: album.genres[0].name, ID: album.id)
            newAlbum.stringToImage(url: album.artworkUrl100)
            newFeed.append(newAlbum)
            
        }
        return newFeed
    }
}
