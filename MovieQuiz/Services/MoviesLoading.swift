//
//  MoviesLoading.swift
//  MovieQuiz
//
//  Created by Максим on 06.09.2024.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
