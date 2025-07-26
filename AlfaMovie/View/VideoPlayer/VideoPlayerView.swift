//
//  VideoPlayerView.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

import UIKit
import WebKit
import SwiftUICore

class VideoPlayerViewController: UIViewController {
    
    lazy var backButton: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        imageView.tintColor = .white
        return imageView
    }()
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            config.mediaTypesRequiringUserActionForPlayback = []
        } else {
            config.requiresUserActionForMediaPlayback = false
        }

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        return webView
    }()
    var url: String
    let autoPlay: Bool
    private var lockedOrientation: UIInterfaceOrientationMask?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return lockedOrientation ?? .all
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    init(url: String, autoPlay: Bool = true, lockedOrientation: UIInterfaceOrientationMask? = .portrait) {
        self.url = url
        self.autoPlay = autoPlay
        self.lockedOrientation = lockedOrientation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addWebView()
        addImageView()
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setOrientation(.landscape, andRotateTo: .landscapeLeft)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setOrientation(.portrait, andRotateTo: .portrait)
    }
    
    func addWebView(){
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func addImageView(){
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: view.frame.height / 20),
            NSLayoutConstraint(item: backButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: view.frame.width / 10),
            NSLayoutConstraint(item: backButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24),
            NSLayoutConstraint(item: backButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)
        ])
    }
    
    private func load(){
        guard let url = URL(string: url) else{return}
        webView.load(URLRequest(url: url))
    }
    
    func setOrientation(_ mask: UIInterfaceOrientationMask, andRotateTo orientation: UIInterfaceOrientation) {
        self.lockedOrientation = mask
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    @objc func back(){
        dismiss(animated: true)
    }
}

extension VideoPlayerViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView,didFinish navigation: WKNavigation!) {
        print("loaded")
    }

}
