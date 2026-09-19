//
//  CoverImageEncoding.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.09.2026.
//

import UIKit

enum CoverImageEncoding {
    static func toCoverDataURI(_ image: UIImage, maxDimension: CGFloat = 1080, quality: CGFloat = 0.85) -> String? {
        guard let data = resized(image, maxDimension: maxDimension).jpegData(compressionQuality: quality) else {
            return nil
        }
        return "data:image/jpeg;base64,\(data.base64EncodedString())"
    }

    private static func resized(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        let largestSide = max(image.size.width, image.size.height)
        guard largestSide > maxDimension else { return image }

        let scale = maxDimension / largestSide
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in image.draw(in: CGRect(origin: .zero, size: newSize)) }
    }
}
