//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Максим on 31.08.2024.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func show(alertController: UIAlertController)
}
