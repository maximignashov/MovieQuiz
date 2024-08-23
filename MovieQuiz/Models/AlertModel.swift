//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Максим on 22.08.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    
    var completion: (() -> Void)? = nil
}
