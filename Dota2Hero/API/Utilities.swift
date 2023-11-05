//
//  Utilities.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 03.11.2023.
//

import Foundation
import UIKit

class ImageFetcher {
   
    private let cache = NSCache<NSString, UIImage>()
    
    func fetchImage(from url: URL?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = url else { completion(.failure(ImageFetcherError.badURL)); return }
        
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: url.absoluteString as NSString)
                completion(.success(image))
            } else {
                completion(.failure(ImageFetcherError.networkError))
            }
        }
    }
}

enum ImageFetcherError: Error {
    case networkError
    case badURL
}

protocol MakeRolesLabel {
    func configureLabel(with attackType: String, and roles: [String]) -> NSMutableAttributedString
}

extension MakeRolesLabel where Self: UITableViewCell {
   
    func configureLabel(with attackType: String, and roles: [String]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let attackTypeString = NSMutableAttributedString(string: "\(attackType.uppercased()) - ", attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold),
            .foregroundColor: UIColor.black
        ])
        attributedString.append(attackTypeString)
        if !roles.isEmpty {
            let rolesString = roles.map { $0.uppercased() }.joined(separator: ", ")
            let rolesAttributedString = NSAttributedString(string: rolesString, attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.lightGray
            ])
            attributedString.append(rolesAttributedString)
        }
        
        return attributedString
    }
}
