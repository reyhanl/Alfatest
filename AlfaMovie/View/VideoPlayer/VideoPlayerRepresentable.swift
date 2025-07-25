//
//  VideoPlayerRepresentable.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

import SwiftUI

struct VideoPlayerRepresentable: UIViewControllerRepresentable{
    var videoURL: String
    
    func makeUIViewController(context: Context) -> VideoPlayerViewController {
        return VideoPlayerViewController(url: videoURL)
    }
    
    func updateUIViewController(_ uiViewController: VideoPlayerViewController, context: Context) {
        uiViewController.url = videoURL
    }
    
    typealias UIViewControllerType = VideoPlayerViewController    
}
