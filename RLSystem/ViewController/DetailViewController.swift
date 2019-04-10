//
//  DetailViewController.swift
//  
//
//  Created by 相川健太 on 2019/01/13.
//

import UIKit
import RealmSwift
import Alamofire
import AlamofireImage

class DetailViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var culturalTitle: UILabel!
    @IBOutlet weak var culturalTitleYomi: UILabel!
    @IBOutlet weak var culturalContext: UILabel!
    @IBOutlet weak var culturalImage: UIImageView!
    @IBOutlet weak var regionalSegmented: UISegmentedControl!
    @IBOutlet weak var regionalCollectionView: UICollectionView!
    let placeholderImage = UIImage(named: "no_image.png")!
    var urlStr: [String] = []
    var culturalID: Int!
    
    override func viewDidLoad() {
        let cultural = try!Realm().objects(Webmap.self).filter("id==\(culturalID!)")[0]
        let culturalImg = try!Realm().objects(WebmapImage.self).filter("id==\(culturalID!)")[0]
        culturalTitle.text = cultural.title
        culturalTitleYomi.text = cultural.title_yomi
        var culturalText = cultural.context + "\n\n" + cultural.tourist_sign
        
        //文字列（＼）置換
        while true{
            if let range = culturalText.range(of: "\\") {
                // 置換する(変数を直接操作する)
                culturalText.replaceSubrange(range, with: "")
            }else{
                break
            }
        }
        
        culturalContext.text = culturalText
        culturalContext.sizeToFit()
        
        //日本語文字を含むURLをエンコード
        let encodedUrl = (culturalImg.image).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        if let imgurl:URL = URL(string: encodedUrl!){
            culturalImage.af_setImage(withURL:imgurl, placeholderImage: placeholderImage)
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch regionalSegmented.selectedSegmentIndex{
        case 0:
            let jinbutsuCollection = try!Realm().objects(RJinbutsu.self).filter("webmap_id==\(culturalID!)")
//            let jinbutsuCollection = try!Realm().objects(RJinbutsu.self).filter("webmap_id==\(culturalID!) && match_words > 1")
            return jinbutsuCollection.count
        case 1:
            let shishiCollection = try!Realm().objects(RShishi.self).filter("webmap_id==\(culturalID!)")
//            let shishiCollection = try!Realm().objects(RShishi.self).filter("webmap_id==\(culturalID!) && match_words > 1")
            return shishiCollection.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegionalCell", for: indexPath) as! RegionalCollectionViewCell
        switch regionalSegmented.selectedSegmentIndex{
        case 0:
            let jinbutsuCollection = try!Realm().objects(RJinbutsu.self).filter("webmap_id==\(culturalID!)")
//            let jinbutsuCollection = try!Realm().objects(RJinbutsu.self).filter("webmap_id==\(culturalID!) && match_words > 1")
            let person = jinbutsuCollection[indexPath.row]
            let personInfo = try!Realm().objects(Jinbutsu.self).filter("id==\(person.jinbutsu_id)")[0]
            urlStr.append(personInfo.url)
            let featureInfo = try!Realm().objects(JinbutsuTfidf.self).filter("id==\(person.jinbutsu_id)")[0]
            cell.regionalName.text = personInfo.name
            cell.regionalImage.image = UIImage(named: "no_image.png")
            if let imgurl:URL = URL(string: personInfo.imgUrl){
                cell.regionalImage.af_setImage(withURL:imgurl, placeholderImage: placeholderImage)
            }
            
            let match_words = [person.word1, person.word2, person.word3, person.word4, person.word5]
            cell.matchWord.text = ""
            for word in match_words{
                if word != ""{
                    cell.matchWord.text = cell.matchWord.text! + word + "，"
                }
            }
            cell.matchWord.text = cell.matchWord.text! + "で関連"
            cell.featureWord1.text = featureInfo.tfidf1
            cell.featureWord2.text = featureInfo.tfidf2
            cell.featureWord3.text = featureInfo.tfidf3
            cell.featureWord4.text = featureInfo.tfidf4
            cell.featureWord5.text = featureInfo.tfidf5
            for word in match_words{
                if word.contains(featureInfo.tfidf1){
                    if getMatchCount(targetString: word) != 0{
                        cell.featureWord1.textColor = UIColor.blue
                    }else if word == featureInfo.tfidf1{
                        cell.featureWord1.textColor = UIColor.red
                    }
                }
                if word.contains(featureInfo.tfidf2){
                    if getMatchCount(targetString: word) != 0{
                        cell.featureWord2.textColor = UIColor.blue
                    }else if word == featureInfo.tfidf2{
                        cell.featureWord2.textColor = UIColor.red
                    }
                }
                if word.contains(featureInfo.tfidf3){
                    if getMatchCount(targetString: word) != 0{
                        cell.featureWord3.textColor = UIColor.blue
                    }else if word == featureInfo.tfidf3{
                        cell.featureWord3.textColor = UIColor.red
                    }
                }
                if word.contains(featureInfo.tfidf4){
                    if getMatchCount(targetString: word) != 0{
                        cell.featureWord4.textColor = UIColor.blue
                    }else if word == featureInfo.tfidf4{
                        cell.featureWord4.textColor = UIColor.red
                    }
                }
                if word.contains(featureInfo.tfidf5){
                    if getMatchCount(targetString: word) != 0{
                        cell.featureWord5.textColor = UIColor.blue
                    }else if word == featureInfo.tfidf5{
                        cell.featureWord5.textColor = UIColor.red
                    }
                }
            }
        case 1:
            let shishiCollection = try!Realm().objects(RShishi.self).filter("webmap_id==\(culturalID!)")
//            let shishiCollection = try!Realm().objects(RShishi.self).filter("webmap_id==\(culturalID!) && match_words > 1")
            let history = shishiCollection[indexPath.row]
            let historyInfo = try!Realm().objects(Shishi.self).filter("id==\(history.shishi_id)")[0]
            urlStr.append(historyInfo.url)
            let featureInfo = try!Realm().objects(ShishiTfidf.self).filter("id==\(history.shishi_id)")[0]
            cell.regionalName.text = historyInfo.paragraph_title
            cell.regionalImage.image = UIImage(named: "no_image.png")
            if let imgurl:URL = URL(string: historyInfo.image_url){
                cell.regionalImage.af_setImage(withURL:imgurl, placeholderImage: placeholderImage)
            }
            let match_words = [history.word1, history.word2, history.word3, history.word4, history.word5]
            cell.matchWord.text = ""
            for word in match_words{
                if word != ""{
                    cell.matchWord.text = cell.matchWord.text! + word + "，"
                }
            }
            cell.matchWord.text = cell.matchWord.text! + "で関連"
            cell.featureWord1.text = featureInfo.tfidf1
            cell.featureWord2.text = featureInfo.tfidf2
            cell.featureWord3.text = featureInfo.tfidf3
            cell.featureWord4.text = featureInfo.tfidf4
            cell.featureWord5.text = featureInfo.tfidf5
            for word in match_words{
                if word.contains(featureInfo.tfidf1){
                    if getMatchCount(targetString: word) != 0{
                        cell.featureWord1.textColor = UIColor.blue
                    }else if word == featureInfo.tfidf1{
                        cell.featureWord1.textColor = UIColor.red
                    }
                }
                if word.contains(featureInfo.tfidf2){
                    if getMatchCount(targetString: word) != 0{
                        cell.featureWord2.textColor = UIColor.blue
                    }else if word == featureInfo.tfidf2{
                        cell.featureWord2.textColor = UIColor.red
                    }
                }
                if word.contains(featureInfo.tfidf3){
                    if getMatchCount(targetString: word) != 0{
                        cell.featureWord3.textColor = UIColor.blue
                    }else if word == featureInfo.tfidf3{
                        cell.featureWord3.textColor = UIColor.red
                    }
                }
                if word.contains(featureInfo.tfidf4){
                    if getMatchCount(targetString: word) != 0{
                        cell.featureWord4.textColor = UIColor.blue
                    }else if word == featureInfo.tfidf4{
                        cell.featureWord4.textColor = UIColor.red
                    }
                }
                if word.contains(featureInfo.tfidf5){
                    if getMatchCount(targetString: word) != 0{
                        cell.featureWord5.textColor = UIColor.blue
                    }else if word == featureInfo.tfidf5{
                        cell.featureWord5.textColor = UIColor.red
                    }
                }
            }
        default:
            print("damedayo")
        }
        
        return cell
    }
    
    // 正規表現にマッチした数を返す
    func getMatchCount(targetString: String) -> Int {
        
        do {
            let pattern = "(?<=\\().*?(?=\\))"
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            let targetStringRange = NSRange(location: 0, length: (targetString as NSString).length)
            
            return regex.numberOfMatches(in: targetString, options: [], range: targetStringRange)
            
        } catch {
            print("error: getMatchCount")
        }
        return 0
    }
    
    // 正規表現にマッチした文字列を格納した配列を返す
    func getMatchStrings(targetString: String) -> [String] {
        
        var matchStrings:[String] = []
        let pattern = "(?<=\\().*?(?=\\))"
        
        do {
            
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let targetStringRange = NSRange(location: 0, length: (targetString as NSString).length)
            
            let matches = regex.matches(in: targetString, options: [], range: targetStringRange)
            
            for match in matches {
                
                // rangeAtIndexに0を渡すとマッチ全体が、1以降を渡すと括弧でグループにした部分マッチが返される
                let range = match.range(at: 0)
                let result = (targetString as NSString).substring(with: range)
                
                matchStrings.append(result)
            }
            
            return matchStrings
            
        } catch {
            print("error: getMatchStrings")
        }
        return []
    }
    
    @IBAction func detailButton(_ sender: UIButton) {
        let btn = sender
        let cell = btn.superview?.superview as! UICollectionViewCell
        let row = regionalCollectionView.indexPath(for: cell)?.row
        let url = URL(string: urlStr[row!])!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func regionalSegmented(_ sender: UISegmentedControl) {
        //セグメント番号で条件分岐させる
        switch sender.selectedSegmentIndex {
        case 0:
            urlStr.removeAll()
            regionalCollectionView.reloadData()
            print("case 0")
        case 1:
            urlStr.removeAll()
            regionalCollectionView.reloadData()
            print("case 1")
        default:
            print("no case")
        }
    }
    
}
