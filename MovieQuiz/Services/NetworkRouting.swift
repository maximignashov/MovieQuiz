//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Максим on 13.09.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
