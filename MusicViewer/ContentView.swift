//
//  ContentView.swift
//  MusicViewer
//
//  Created by Kazim Walji on 5/21/21.
//

import SwiftUI

struct ContentView: View {
    @State private var albums: [Album]?
    var body: some View {
        if let albums = FetchData.getAlbums(urlString: "https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/15/explicit.json") {
            NavigationView {
                List {
                    ForEach(albums, id: \.self) { album in
                        NavigationLink(destination: AlbummVC(album: album)) {
                            AlbumRow(album: album)
                        }.buttonStyle(PlainButtonStyle()).offset(x: -20).navigationTitle("Albums")
                    }
                }.navigationTitle("Albums")
            }
        } else {
            Text("No Connection")
        }
    }
}

struct AlbumRow: View {
    @State var album: Album
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                Image(uiImage: album.image).resizable()
                    .frame(width: 50.0, height: 50.0)
                VStack (alignment: .leading) {
                    Text(album.name).foregroundColor(colorScheme == .dark ? Color.white : Color.black).font(.title2).frame(width: 270, alignment: .leading).fixedSize(horizontal: true, vertical: false).lineLimit(1)
                    Text(album.artistName).foregroundColor(.gray).font(.body).frame(width: 270, alignment: .leading).fixedSize(horizontal: true, vertical: false).lineLimit(1)
                }        }
        }.padding()
    }
}

struct AlbummVC: View {
    @State var album: Album
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            Group {
                Text(album.name).font(.title).frame(width: UIScreen.screenWidth - 40, alignment: .center).fixedSize(horizontal: true, vertical: false)
                Text(album.artistName).foregroundColor(.gray).font(.title3).frame(width: 400, alignment: .center).fixedSize(horizontal: true, vertical: false)
                Image(uiImage: album.image).resizable()
                    .frame(width: 300.0, height: 300.0)
                Text(album.copyright).font(.footnote).frame(width: UIScreen.screenWidth - 40, alignment: .center).fixedSize(horizontal: true, vertical: false).lineLimit(1)
                Text("Genre: " + album.genre).font(.title3).offset(y: 10)
                Text("Released " + album.releaseDate).font(.title3).offset(y: 10)
            }.offset(y: 20)
            Spacer()
            Button(action: {
                let newName = album.name.replacingOccurrences(of: " ", with: "-")
                let urlString = "itms://itunes.apple.com/us/album/" + newName + "/id" + album.id
                if let finalString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    if let url  = URL(string: finalString) {
                        if UIApplication.shared.canOpenURL(url as URL) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
            }) {
                Text("View in iTunes").font(.system(size: 25, weight: .heavy, design: .default)).foregroundColor(colorScheme == .dark ? Color.black : Color.white).padding().frame(minWidth: 350).background(colorScheme == .dark ? Color.white : Color.black).cornerRadius(30)
            }.frame(maxHeight: .infinity, alignment: .bottom)
            Spacer().frame(height: 20, alignment: .bottom)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
}
