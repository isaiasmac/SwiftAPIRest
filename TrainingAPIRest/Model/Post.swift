//
//  Post.swift
//  TrainingAPIRest
//
//  Created by Isaías on 5/3/18.
//  Copyright © 2018 Isaías. All rights reserved.
//

import Foundation

class Post: NSObject {
    var id: Int
    var userId: Int
    var title: String?
    var body: String?
    
    init(id: Int, userId: Int){
        self.id = id
        self.userId = userId
    }
    
}
