//  AppUtility.swift
//  Created by Dominik Hel on 19.03.2022.

//  MARK: - Imports
import Foundation
import UIKit

//  MARK: - Struct AppUtility
struct AppUtility {
    //  MARK: - Functions
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
}
