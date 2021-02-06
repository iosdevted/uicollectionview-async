//
//  CustomImageView.swift
//  uicollectionview-async
//
//  Created by Ted on 2021/02/06.
//

import UIKit

// Image Caching
var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var isLoading: Bool {
        get { return activityIndicator.isAnimating }
        set {
            if newValue {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        self.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        return indicator
    }()
    
    // Check the path
    var lastImgUrlUsedToLoadImage: String?
    
    func loadImage(with urlString: String) {
        
        self.image = nil
        
        // The String path which is downloaded last time
        lastImgUrlUsedToLoadImage = urlString
        
        // Check if there is a cache
        if let cachedIamge = imageCache[urlString] {
            self.image = cachedIamge
            self.isLoading = false
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        // URLSession
        URLSession.shared.dataTask(with: url) { (data, reponse, error) in
            
            if let error = error {
                print("Failed to load image with error", error.localizedDescription)
            }
            
            if self.lastImgUrlUsedToLoadImage != url.absoluteString {
                return
            }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            
            // Save a cache
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
                self.isLoading = false
            }
        }.resume()
    }
}
