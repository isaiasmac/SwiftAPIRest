//
//  PostModel.swift
//  TrainingAPIRest
//
//  Created by Isaías on 5/3/18.
//  Copyright © 2018 Isaías. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PostModel{
    
    static let BASE_URL: String = "https://jsonplaceholder.typicode.com/posts"
    static weak var delegate: PostModelDelegate?
    
    static func getPostsWithCallbackV1(completion: @escaping (Bool) -> ()){
        Alamofire.request(BASE_URL).responseJSON { response in
            if let json = response.result.value {
                completion(true)
            }
            else{
                completion(false)
            }
        }
    }
    
    // Prueba de function con completion
    static func getPostsWithCallbackV2(completion: @escaping (Bool, [Post]?) -> ()){
        var postArray: [Post] = []
        
        Alamofire.request(BASE_URL).responseJSON { response in
            if let json = response.result.value {
                let jsonObject = JSON(json)
                //print("jsonObject => \(jsonObject)")
                
                for p in (jsonObject.array)!{
                    let post: Post = self.parsePostFromJson(p)
                    postArray.append(post)
                }
                
                completion(true, postArray)
            }
            else{
                completion(false, nil)
            }
        }
    }
    
    static func getPostsWithDelegation() throws{
        if self.delegate == nil {
            throw MyError.delegateError("PostModelDelegate no implementado")
            // Comentado (throw...) para probar las 3 formas de entregar datos desde el Modelo hacia el Controlador
        }
        
        var postArray: [Post] = []
        
        Alamofire.request(BASE_URL).responseJSON { response in
            if let json = response.result.value {
                let jsonObject = JSON(json)
                //print("jsonObject => \(jsonObject)")
                
                for p in (jsonObject.array)!{
                    let post: Post = self.parsePostFromJson(p)
                    postArray.append(post)
                }
                
                self.delegate?.didRecievePostsData(data: postArray)
            }
        }
    }
    
    public static let justRecievePostsData = "justRecievePostsData"
    static func getPostsWithNotification(){
        var postArray: [Post] = []
        Alamofire.request(BASE_URL).responseJSON { response in
            if let json = response.result.value {
                let jsonObject = JSON(json)
                //print("jsonObject => \(jsonObject)")
                
                for p in (jsonObject.array)!{
                    let post: Post = self.parsePostFromJson(p)
                    postArray.append(post)
                }
                
                //let data: [String: [Post]] = ["postArray": postArray]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: justRecievePostsData), object: nil, userInfo: ["postArray": postArray])
            }
        }
        
    }
    
    private static func parsePostFromJson(_ postJson: JSON) -> Post{
        let id: Int = postJson["id"].intValue
        let userId: Int = postJson["userId"].intValue
        let title: String = postJson["title"].stringValue
        let body: String = postJson["body"].stringValue
        
        let post: Post = Post(id: id, userId: userId)
        post.body = body
        post.title = title
        
        return post
    }
}


protocol PostModelDelegate: class {
    func didRecievePostsData(data: [Post])
}

