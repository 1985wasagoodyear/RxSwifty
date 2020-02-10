//
//  UIImage+resize.swift
//  RxSwifty
//
//  Created by K Y on 11/13/19.
//  Copyright © 2019 Kevin Yu. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(for size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
