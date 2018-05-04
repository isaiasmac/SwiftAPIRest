//
//  ViewController.swift
//  TrainingAPIRest
//
//  Created by Isaías on 5/3/18.
//  Copyright © 2018 Isaías. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, PostModelDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var postsArray: [Post] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getPostsData(_:)),
                                               name: NSNotification.Name(rawValue: PostModel.justRecievePostsData),
                                               object: nil)
        
        self.tableView.dataSource = self
        PostModel.delegate = self
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PostModel.justRecievePostsData), object: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
//        do {
//            try PostModel.getPostsWithDelegation()
//        } catch MyError.delegateError(let message){
//            print("Error PostModel ==> \(message)")
//        }
//        catch MyError.runtimeError(let message){
//            print("Error PostModel ==> \(message)")
//        }
//        catch{
//            print("Error PostModel")
//        }
        
    }
    
    func clearTable() {
        self.postsArray.removeAll()
        self.tableView.reloadData()
    }
    
    //MARK: Button Actions
    @IBAction func completionAction(_ sender: UIButton) {
        clearTable()
        
        HUD.flash(.progress)
        
        PostModel.getPostsWithCallbackV2 { (success, mpostArray) in
            HUD.hide()
            
            if success == true{
                self.postsArray = mpostArray!
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func delegateAction(_ sender: UIButton) {
        clearTable()
        HUD.flash(.progress)
        do {
            try PostModel.getPostsWithDelegation()
        } catch  {
            print("Error al obtener la data con Delegation")
        }
        
    }
    
    @IBAction func notificationAction(_ sender: UIButton) {
        clearTable()
        HUD.flash(.progress)
        PostModel.getPostsWithNotification()
    }
    
    //MARK: PostModel Delegate
    func didRecievePostsData(data: [Post]) {
        HUD.hide()
        self.postsArray = data
        self.tableView.reloadData()
    }
    
    //MARK: Notification Method
    @objc func getPostsData(_ notification: NSNotification){
        //print("getPostsData called")
        HUD.hide()
        
        if let dict = notification.userInfo as? Dictionary<String, [Post]> {
            let mpostsArray = dict["postArray"]
            
            self.postsArray = mpostsArray!
            self.tableView.reloadData()
        }
        
//        if let dat = notification.userInfo as NSDictionary? {
//            let postsArray = dat.object(forKey: "postArray") as? NSArray
//            //print("Data => \(String(describing: postsArray))")
//        }
    }
    
    //MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostCell
        
        let post: Post = postsArray[indexPath.row]
        cell.titleLabel.text = post.title
        cell.bodyLabel.text = post.body
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.postsArray.count
    }

}

