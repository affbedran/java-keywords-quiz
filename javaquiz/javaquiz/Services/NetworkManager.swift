//
//  NetworkManager.swift
//  javaquiz
//
//  Created by André Felipe Fleck Bedran on 24/08/19.
//  Copyright © 2019 André Bedran. All rights reserved.
//

import Foundation

class NetworkManager {

    static let shared = NetworkManager()
    static let configuration = URLSessionConfiguration.default
    let session: URLSession
    let baseURL: String

    private init(baseURL: String = "https://codechallenge.arctouch.com/quiz") {
        self.baseURL = baseURL
        self.session = URLSession(configuration: NetworkManager.configuration)
    }
    
    func requestQuiz(at path: Path, completion: @escaping (Data?, Error?) -> Void) {
        if let url = URL(string: baseURL)?.appendingPathComponent(path.rawValue) {
            let task = self.session.dataTask(with: url) { (data, response, error) in
                completion(data, error)
            }
            task.resume()
        }
    }

}


enum Path: String {
    case java = "java-keywords"
}
