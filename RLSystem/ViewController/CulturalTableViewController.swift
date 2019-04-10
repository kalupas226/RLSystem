//
//  CulturalViewController.swift
//  RLSystem
//
//  Created by 相川健太 on 2019/01/13.
//  Copyright © 2019年 相川健太. All rights reserved.
//

import UIKit
import RealmSwift

class CulturalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var culturalTable: UITableView!
    var culturalID:Int!
    let placeholderImage = UIImage(named: "no_image.png")!
    let moreCultural = [96,318,102,103,16,106,313,275,52,449,450,452]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        culturalTable.delegate = self
        culturalTable.dataSource = self
        culturalTable.register(UINib(nibName: "CulturalTableViewCell", bundle: nil), forCellReuseIdentifier: "CulturalTableViewCell")
        loadSeedRealm()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let culturalCollection = try!Realm().objects(Webmap.self)
//        return culturalCollection.count
        return moreCultural.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CulturalTableViewCell") as! CulturalTableViewCell
//        let culturalCollection = try!Realm().objects(WebmapTag.self).filter("tag = '碑・像'")
        let culturalCollection = try!Realm().objects(Webmap.self).filter("id==\(moreCultural[indexPath.row])")
//        let cultural = culturalCollection[indexPath.row]
        let cultural = culturalCollection[0]
        let culturalImg = try!Realm().objects(WebmapImage.self).filter("id==\(cultural.id)")[0]
        let culturalFeature = try!Realm().objects(WebmapTfidf.self).filter("id==\(cultural.id)")[0]
        let relateJinbutsu = try!Realm().objects(RJinbutsu.self).filter("webmap_id==\(cultural.id)")
//        let relateJinbutsu = try!Realm().objects(RJinbutsu.self).filter("webmap_id==\(cultural.id) && match_words > 1")
        let relateShishi = try!Realm().objects(RShishi.self).filter("webmap_id==\(cultural.id)")
//        let relateShishi = try!Realm().objects(RShishi.self).filter("webmap_id==\(cultural.id) && match_words > 1")
        cell.culturalTitle.text = "文化財名：" + cultural.title
        cell.relateLabel.text = "（関連する人物資料：" + String(relateJinbutsu.count) + "，関連する自治体資料：" + String(relateShishi.count) + "）"
        cell.culturalFeature.text  = "特徴語：" + culturalFeature.tfidf1 + "，" + culturalFeature.tfidf2 + "，" + culturalFeature.tfidf3 + "，" + culturalFeature.tfidf4 + "，" + culturalFeature.tfidf5
        cell.culturalTitle.sizeToFit()
        cell.culturalFeature.sizeToFit()
        
        //日本語文字を含むURLをエンコード
        let encodedUrl = (culturalImg.image).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        cell.culturalImage.image = UIImage(named: "no_image.png")
        if let imgurl:URL = URL(string: encodedUrl!){
            cell.culturalImage.af_setImage(withURL:imgurl, placeholderImage: placeholderImage)
        }
        
//        if relateJinbutsu.count == 0 && relateShishi.count == 0{
//            cell.isHidden = true
//        }else{
//            cell.isHidden = false
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CulturalTableViewCell") as! CulturalTableViewCell
//        if cell.isHidden == true {
//            return 0
//        }else{
//            return 200
//        }
        return 200
    }

    func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
//        let culturalCollection = try!Realm().objects(WebmapTag.self).filter("tag='碑・像'")
        let culturalCollection = try!Realm().objects(Webmap.self).filter("id==\(moreCultural[indexPath.row])")
        let cultural = culturalCollection[0]
        culturalID = cultural.id
        performSegue(withIdentifier: "toDetail",sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toDetail") {
            let detailVC: DetailViewController = (segue.destination as? DetailViewController)!
            detailVC.culturalID = culturalID
        }
    }
    
    func loadSeedRealm(){
        var config = Realm.Configuration()
        let path = Bundle.main.path(forResource: "RLSystem", ofType: "realm")
        
        config.fileURL = URL(string:path!)
        config.readOnly = true
        Realm.Configuration.defaultConfiguration = config
    }
}
