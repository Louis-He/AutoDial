//
//  ViewController.swift
//  AutoDial
//
//  Created by hsw on 17/2/27.
//  Copyright © 2017年 hsw. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI

class ViewController: UIViewController, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {
    let locationManager:CLLocationManager = CLLocationManager()
    let newLabel=UILabel(frame: CGRect(x: 100, y: 200, width: 300, height: 100))
    static var info : String = " "
    
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var referencecity: UILabel!
    
    @IBOutlet weak var referenceplace: UILabel!
    
    @IBOutlet weak var speed: UILabel!
    
    
    @IBAction func TEST(_ sender: UIButton) {
       //UIApplication.shared.openURL(NSURL(string: "tel://18964715920")! as URL)
        if MFMessageComposeViewController.canSendText(){
            let controller = MFMessageComposeViewController()
            //设置短信内容
            controller.body = ViewController.info
            //设置收件人列表
            controller.recipients = ["18964715920"]
            //设置代理
            controller.messageComposeDelegate = self
            //打开界面
            self.present(controller, animated: true, completion: { () -> Void in
                
            })
        }else{
            print("本设备不能发送短信")
        }
    }
    
    //发送短信代理
    func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        if result==MessageComposeResult.sent{
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
            // 创建
            UIAlertController(title: "提示", message: "紧急消息发送成功！", preferredStyle: .alert)
        }
        if result==MessageComposeResult.cancelled{
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
            //_ = UIAlertController(title: "警告", message: "紧急消息发送取消！", preferredStyle: .alert)
            UIAlertController(title: "警告", message: "紧急消息发送取消", preferredStyle: .alert)
        }
        
    }

    @IBAction func Accident(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: "tel://122")! as URL)
    }
    
    @IBAction func Dial(_ sender: UIButton) {
         UIApplication.shared.openURL(NSURL(string: "tel://110")! as URL)
    }
    
    @IBAction func fire(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: "tel://119")! as URL)
    }
    
    @IBAction func Ambulance(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: "tel://120")! as URL)
    }
    
    @IBAction func emergencycall(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: "tel://18964715920")! as URL)
    }
    //定位管理器
    //static let locationManager:CLLocationManager = CLLocationManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        //设置定位模式
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 5
        ////发送授权申请
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {//定位失败
        print(error)
        print("哇靠！！定位怎么失败了呢")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        let currLocation:CLLocation = locations.last!
        //获取经度
        if(currLocation.altitude == -1){
            location.text = String(format: "%.4f", currLocation.coordinate.latitude) + "N," + String(format: "%.4f", currLocation.coordinate.longitude) + "E;未知高度";
        }else{
            location.text = String(format: "%.4f", currLocation.coordinate.latitude) + "N," + String(format: "%.4f", currLocation.coordinate.longitude) + "E;\(String(format: "%.1f", currLocation.altitude))m";
        }
        
        if(currLocation.speed == -1){
             speed.text = "当前速度无法被测量";
        }else{
            speed.text = "Speed: "+"\(String(format: "%.1f", currLocation.speed*3.6))km/h";
        }
        //获取纬度
        //       newLabel.text = "纬度：\(currLocation.coordinate.latitude)"
        //        //获取海拔
        //        newLabel.text = "海拔：\(currLocation.altitude)"
        //        //获取水平精度
        //        newLabel.text = "水平精度：\(currLocation.horizontalAccuracy)"
        //        //获取垂直精度
        //       newLabel.text = "垂直精度：\(currLocation.verticalAccuracy)"
        //        //获取方向
        //        newLabel.text = "方向：\(currLocation.course)"
        //        //获取速度
        //        newLabel.text = "速度：\(currLocation.speed)"  
        
        ////
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currLocation) { (placemark, error) -> Void in
            
            if(error == nil)
            {
                /*
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                //城市
                let city: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                //国家
                let country: String = (mark.addressDictionary! as NSDictionary).value(forKey: "Country") as! String
                //国家编码
                let CountryCode: String = (mark.addressDictionary! as NSDictionary).value(forKey: "CountryCode") as! String
                //街道位置
                let FormattedAddressLines: String = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! String
                //具体位置
                let Name: String = (mark.addressDictionary! as NSDictionary).value(forKey: "Name") as! String
                //省
                var State: String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
                //区
                let SubLocality: String = (mark.addressDictionary! as NSDictionary).value(forKey: "SubLocality") as! String
                
                self.referencecity.text = country + State + city + SubLocality
                if( country + State + city + SubLocality == nil){
                    self.referencecity.text = "未知"
                }
                self.referenceplace.text = Name
                */
                self.referencecity.text = "未知"
                self.referenceplace.text = "未知"
                
                //ViewController.info = "紧急警告：收到一封紧急联系短信！求助地址：" + country + State + city + SubLocality + Name + "；具体经纬度坐标为：" + String(format: "%.4f", currLocation.coordinate.latitude) + "N," + String(format: "%.4f", currLocation.coordinate.longitude) + "E; 请确认紧急状况！"
                ViewController.info = "紧急警告：收到一封紧急联系短信！求助具体经纬度坐标为：" + String(format: "%.4f", currLocation.coordinate.latitude) + "N," + String(format: "%.4f", currLocation.coordinate.longitude) + "E; 请确认紧急状况！"
            }
            else
            {
                print("error")
            }
        }
    }
}

