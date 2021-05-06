//
//  APIService.swift
//  TechBaseVN
//
//  Created by Huy Ong on 4/29/21.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    
    let baseURL = "https://picsum.photos/v2/list?"
    
    func fetchPhotos(pages: Int = 1,limit: Int = 100, completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let url = URL(string: baseURL + "page=\(pages)" + "&limit=\(limit)") else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, res, error in
            if let error = error {
                fatalError("Failed to fetch photo \(error.localizedDescription)")
            }
            
            guard let data = data else { return }

            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                completion(.success(photos))
            } catch let error {
                completion(.failure(error))
            }
        }
        
        session.resume()
    }
    
    
    
}
