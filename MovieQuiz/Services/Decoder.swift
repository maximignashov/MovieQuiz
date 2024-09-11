//
//  Decoder.swift
//  MovieQuiz
//
//  Created by Максим on 11.09.2024.
//

import Foundation

struct Decoder {
    
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    func decode(mostPopularMoviesUrl: URL, handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
