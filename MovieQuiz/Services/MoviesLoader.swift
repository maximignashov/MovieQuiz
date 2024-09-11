//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Максим on 06.09.2024.
//

import Foundation

struct MoviesLoader: MoviesLoading {
    
    // MARK: - Decoder
    private let decoder = Decoder()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        decoder.decode(mostPopularMoviesUrl: mostPopularMoviesUrl,
                       handler: handler
        )
    }
}
