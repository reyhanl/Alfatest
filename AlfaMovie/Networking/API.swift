//
//  API.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

class APIEndpoint{
   static var baseURL: String = "https://api.themoviedb.org/3"
   static var imagePath: String = "https://image.tmdb.org/t/p/"
   static var nowPlaying: String = "/movie/now_playing"
   static var discover: String = "/discover/movie"
    
    static func baseImagePath(size: Int) -> String{
        return imagePath + "/w\(size)/"
    }
    
    static func imagePath(imagePath: String, size: Int = 200) -> String{
        return baseImagePath(size: size) + imagePath
    }
}
