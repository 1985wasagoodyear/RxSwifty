//
//  ImageProvider.swift
//  RxSwifty
//
//  Created by K Y on 11/13/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import Foundation

typealias DataCompletion = (Data?) -> Void

final class ImageProvider {
    
    private let cache = NSCache<NSString, NSData>()
    
    let session: URLSession
    
    init(_ session: URLSession) {
        self.session = session
    }
    
    /// performs completion on main thread
    func getImage(_ urlString: String, completion: (DataCompletion)?) {
        if let imageData = cache.object(forKey: urlString as NSString) {
            completion?(Data(referencing: imageData))
            return
        }
        guard let url = URL(string: urlString) else {
            completion?(nil)
            return
        }
        completion?(nil)
        session.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                guard let imageData = data else {
                    completion?(nil)
                    return
                }
                self.cache.setObject(NSData(data: imageData),
                                     forKey: urlString as NSString)
                completion?(imageData)
            }
        }.resume()
    }
}
