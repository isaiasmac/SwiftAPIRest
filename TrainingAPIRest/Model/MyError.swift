//
//  MyError.swift
//  TrainingAPIRest
//
//  Created by Isaías on 5/3/18.
//  Copyright © 2018 Isaías. All rights reserved.
//

import Foundation

enum MyError: Error {
    case runtimeError(String)
    case delegateError(String)
}
