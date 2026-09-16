//
//  ImageCompressor.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 16.09.2026.
//

import UIKit

enum ImageCompressor {
    static let defaultMaxDimension: CGFloat = 1920
    static let defaultJPEGQuality: CGFloat = 0.85

    static func compressJPEG(
        _ data: Data,
        maxDimension: CGFloat = defaultMaxDimension,
        quality: CGFloat = defaultJPEGQuality
    ) -> Data {
        guard let image = UIImage(data: data) else { return data }

        let longestSide = max(image.size.width, image.size.height)
        let scaledImage: UIImage

        if longestSide > maxDimension {
            let scale = maxDimension / longestSide
            let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
            let renderer = UIGraphicsImageRenderer(size: newSize)
            scaledImage = renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: newSize))
            }
        } else {
            scaledImage = image
        }

        return scaledImage.jpegData(compressionQuality: quality) ?? data
    }
}

extension MultipartFile {
    static func compressedJPEGs(
        _ photos: [Data],
        fieldName: String = "photos",
        maxDimension: CGFloat = ImageCompressor.defaultMaxDimension,
        quality: CGFloat = ImageCompressor.defaultJPEGQuality
    ) -> [MultipartFile] {
        photos.enumerated().map { index, data in
            MultipartFile(
                name: fieldName,
                filename: "photo_\(index).jpg",
                data: ImageCompressor.compressJPEG(data, maxDimension: maxDimension, quality: quality),
                mimeType: "image/jpeg"
            )
        }
    }
}
