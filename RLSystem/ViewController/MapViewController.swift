//
//  MapViewController.swift
//  RLSystem
//
//  Created by 相川健太 on 2019/02/12.
//  Copyright © 2019 相川健太. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, MKMapViewDelegate {
    
    @IBOutlet weak var CulturalMapView: MKMapView!
    @IBOutlet weak var CulturalCollectionView: UICollectionView!
    let placeholderImage = UIImage(named: "no_image.png")!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var jinbutsuTable: UITableView!
    var annotationArray:[MKPointAnnotation] = []
    var jinbutsuAnnotation:[MKPointAnnotation] = []
    var displayCultural:[Int] = []
    var allCultural:[Int] = []
    var latitude: CLLocationDegrees = 41.7819156
    var longitude: CLLocationDegrees = 140.7907615
    var selectedRow:Int!
    var culturalID:Int!
    var culturalTitle:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CulturalMapView.delegate = self
        jinbutsuTable.delegate = self
        jinbutsuTable.dataSource = self
        jinbutsuTable.register(UINib(nibName: "JinbutsuTableViewCell", bundle: nil), forCellReuseIdentifier: "JinbutsuTableViewCell")
        
        loadSeedRealm()
        
        let coordinate = CLLocationCoordinate2DMake(41.7819156, 140.7907615)
        let span = MKCoordinateSpan(latitudeDelta: 2.5, longitudeDelta: 2.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        CulturalMapView.setRegion(region, animated:true)
        
        let culturalCollection = try!Realm().objects(Webmap.self)
        for cultural in culturalCollection{
            let location = try!Realm().objects(WebMapLocation.self).filter("webmap_id==\(cultural.id)")[0]
            if location.lat != ""{
                latitude = Double(location.lat)!
            }
            if location.lng != ""{
                longitude = Double(location.lng)!
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            annotation.title = cultural.title
            annotationArray.append(annotation)
            displayCultural.append(cultural.id)
            allCultural.append(cultural.id)
        }
        CulturalCollectionView.layer.borderColor = UIColor.black.cgColor
        CulturalCollectionView.layer.borderWidth = 1

        for annotation in annotationArray{
            self.CulturalMapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            view.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        culturalTitle = view.annotation!.title!!
        print(culturalTitle)
        let culturalCollection = try!Realm().objects(Webmap.self).filter("title like '\(culturalTitle!)'")
        let cultural = culturalCollection[0]
        culturalID = cultural.id
        performSegue(withIdentifier: "toDetail",sender: nil)
    }
    
    //アノテーションビューを返すメソッド
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //アノテーションビューを生成する。
        let testPinView = MKPinAnnotationView()
        //アノテーションビューに座標、タイトル、サブタイトルを設定する。
        testPinView.annotation = annotation
        //アノテーションビューに色を設定する。
        if annotation.subtitle == "人物と関連"{
            testPinView.pinTintColor = UIColor.blue
        }
        //吹き出しの表示をONにする。
        testPinView.canShowCallout = true
        return testPinView
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let jinbutsuCollection = try!Realm().objects(Jinbutsu.self)
        return jinbutsuCollection.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JinbutsuTableViewCell") as! JinbutsuTableViewCell
        let jinbutsuCollection = try!Realm().objects(Jinbutsu.self)
        let jinbutsu = jinbutsuCollection[indexPath.row]
        let relateNumber = try!Realm().objects(RJinbutsu.self).filter("jinbutsu_id==\(jinbutsu.id)").count
        let encodedUrl = (jinbutsu.imgUrl).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        cell.JinbutsuLabel.text = jinbutsu.name
        cell.JinbutsuImg.image = UIImage(named: "no_image.png")
        cell.relateNum.text = "関連数：" + String(relateNumber)
        if let imgurl:URL = URL(string: encodedUrl!){
            cell.JinbutsuImg.af_setImage(withURL:imgurl, placeholderImage: placeholderImage)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func jinbutsuClear(_ sender: Any) {
        listLabel.text = "全ての文化財一覧"
        listLabel.sizeToFit()
        displayCultural.removeAll()
        CulturalMapView.removeAnnotations(jinbutsuAnnotation)
        jinbutsuAnnotation.removeAll()
        CulturalMapView.removeAnnotations(annotationArray)
        displayCultural = allCultural
        for annotation in annotationArray{
            self.CulturalMapView.addAnnotation(annotation)
        }
        CulturalMapView.reloadInputViews()
        CulturalCollectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let jinbutsuCollection = try!Realm().objects(Jinbutsu.self)
        let relateCulturalCol = try!Realm().objects(RJinbutsu.self).filter("jinbutsu_id==\(jinbutsuCollection[indexPath.row].id)")
        var jinbutsuName = jinbutsuCollection[indexPath.row].name
        //文字列（＼）置換
        while true{
            if let range = jinbutsuName.range(of: "\n") {
                // 置換する(変数を直接操作する)
                jinbutsuName.replaceSubrange(range, with: "")
            }else{
                break
            }
        }
        listLabel.text = "マップ上の文化財一覧（" + jinbutsuName + "と関連）"
        listLabel.sizeToFit()
        self.CulturalMapView.removeAnnotations(jinbutsuAnnotation)
        self.CulturalMapView.removeAnnotations(annotationArray)
        displayCultural.removeAll()
        jinbutsuAnnotation.removeAll()
        for cultural in relateCulturalCol{
            let location = try!Realm().objects(WebMapLocation.self).filter("webmap_id==\(cultural.webmap_id)")[0]
            if location.lat != ""{
                latitude = Double(location.lat)!
            }
            if location.lng != ""{
                longitude = Double(location.lng)!
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let culTitle = try!Realm().objects(Webmap.self).filter("id==\(cultural.webmap_id)")[0]
            annotation.title = culTitle.title
            annotation.subtitle = "人物と関連"
            displayCultural.append(cultural.webmap_id)
            print(displayCultural)
            jinbutsuAnnotation.append(annotation)
        }
        CulturalMapView.reloadInputViews()
        CulturalCollectionView.reloadData()
        for annotation in jinbutsuAnnotation{
            self.CulturalMapView.addAnnotation(annotation)
        }
    }
    
    // TODO: deselect処理を実装しないと効果を発揮しない（実装する）
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        listLabel.text = "全ての文化財一覧"
        listLabel.sizeToFit()
        displayCultural.removeAll()
        jinbutsuAnnotation.removeAll()
        displayCultural = allCultural
        for annotation in annotationArray{
            self.CulturalMapView.addAnnotation(annotation)
        }
        CulturalMapView.reloadInputViews()
        CulturalCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayCultural.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CulturalCell", for: indexPath) as! CulturalCollectionViewCell
        let culturalNo = displayCultural[indexPath.row]
        let cultural = try!Realm().objects(Webmap.self).filter("id==\(culturalNo)")[0]
        cell.culturalTitle.text = cultural.title
        let culturalImg = try!Realm().objects(WebmapImage.self).filter("id==\(culturalNo)")[0]
        
        let imgUrl = culturalImg.image
        let encodedUrl = (imgUrl).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        cell.culturalImage.image = UIImage(named: "no_image.png")
        if let imgurl:URL = URL(string: encodedUrl!){
            cell.culturalImage.af_setImage(withURL:imgurl, placeholderImage: placeholderImage)
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        culturalID = displayCultural[indexPath.row]
//        if culturalID != nil{
//            performSegue(withIdentifier: "toDetail",sender: nil)
//        }
//    }
    
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
