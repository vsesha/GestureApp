//
//  ViewController.swift
//  GestureRecognize
//
//  Created by Vasudevan Seshadri on 7/6/17.
//  Copyright © 2017 Vasudevan Seshadri. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {


    @IBOutlet weak var s_SymbolLabel: UILabel!

    @IBOutlet weak var s_UnlikedCounter: UILabel!
    @IBOutlet weak var s_Price: UILabel!
    
    @IBOutlet weak var s_PctChange: UILabel!
    @IBOutlet weak var s_LikedCounter: UILabel!
    
    @IBOutlet weak var s_LoadPrevSymbol: UIButton!
    
    @IBOutlet weak var s_LoadNextSymbol: UIButton!
    @IBOutlet weak var s_UnlikeButton: UIButton!

    @IBOutlet weak var s_SymbolNotes1: UILabel!
    @IBOutlet weak var s_LikeButton: UIButton!
    
    
    @IBOutlet weak var s_Reset: UIButton!
    
    
    var b_isSensitive: Bool = false
    var count:Int           = -1
    var lastDragVelocity    = CGPoint()
    
    
    var motionManager:CMMotionManager!
    var startedLeftTilt     = false
    var startedRightTilt    = false
    var dateLastShake       = NSDate(timeIntervalSinceNow: -1)
    var dateStartedTilt     = NSDate(timeIntervalSinceNow: -1)
    let tresholdFirstMove   = 5.0
    let tresholdBackMove    = 0.75
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUnicodeToButtons()
        GLOBAL_INITILIZE()
        getSymbol(isNextSymbol: true,didOriginateFromButtons: true)
        //getNextSymbol(goNextSymbol:true as AnyObject)
        usePanGesture()
        paintViewBlackColor()
        motionManager = CMMotionManager()
        
        motionManager.deviceMotionUpdateInterval    = 0.001
        motionManager.gyroUpdateInterval            = 0.001
        
        addEffectToObjects()
    
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: { (gyroData, error) -> Void in
            self.handleGyroData(rotation: (gyroData?.rotationRate)!)
        })
        
        
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    
    private func handleGyroData(rotation: CMRotationRate) {
        
        if fabs(rotation.z) > tresholdFirstMove && fabs(dateLastShake.timeIntervalSinceNow) > 0.2
        {
            if !startedRightTilt && !startedLeftTilt
            {
                dateStartedTilt = NSDate()
                if (rotation.z > 0)
                {
                    startedLeftTilt = true
                    startedRightTilt = false
                }
                else
                {
                    startedRightTilt = true
                    startedLeftTilt = false
                }
            }
        }
        
        if fabs(dateStartedTilt.timeIntervalSinceNow) >= 0.2
        {
            startedRightTilt = false
            startedLeftTilt = false
        }
        else
        {
            if (fabs(rotation.z) > tresholdBackMove)
            {
                if startedLeftTilt && rotation.z < 0
                {
                    NSLog("Left")
                    dateLastShake = NSDate()
                    startedRightTilt = false
                    startedLeftTilt = false
                    paintRedColor()
                    performAction(likeStock: false)
                    getSymbol(isNextSymbol: true)
                }
                else if startedRightTilt && rotation.z > 0
                {
                    NSLog("Right")
                    dateLastShake = NSDate()
                    startedRightTilt = false
                    startedLeftTilt = false
                    paintGreenColor()
                    performAction(likeStock: true)
                    getSymbol(isNextSymbol: true)
                }
            }
        }
        
    }
    
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        //NSLog("Motion begin \(motion) ")
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        NSLog("Motion raw value = \(motion.rawValue)")
        //NSLog("Motion ended")
    }
    
    
    @IBAction func b_PreviousSymbolTouched(_ sender: Any) {
        getSymbol(isNextSymbol: false, didOriginateFromButtons: true)
    }
    
    @IBAction func b_NextSymbolButtonTouched(_ sender: Any) {
        getSymbol(isNextSymbol: true, didOriginateFromButtons: true)
    }
    
    
    
    @IBAction func b_LikeButtonTouched(_ sender: UIButton) {
        paintGreenColor()
        performAction(likeStock: true)
        getSymbol(isNextSymbol: true)
        
    }
    
   
    @IBAction func b_UnlikeButtonTouched(_ sender: UIButton) {
        paintRedColor()
        performAction(likeStock: false)
        getSymbol(isNextSymbol: true)
    }


    
    @IBAction func b_ResetButtonTouched(_ sender: UIButton) {
        
        performResetAction()
        paintBlackColor()
    }
    
    
    
    func paintGreenColor(){
        UIView.animate(withDuration: 0.25, delay: 0.0, animations: {
            self.s_SymbolLabel.layer.backgroundColor = UIColor(red: 0, green: 185/255, blue: 0, alpha: 0.80).cgColor
        })
    }
    func paintRedColor(){
        UIView.animate(withDuration: 0.25, delay: 0.0, animations: {
            self.s_SymbolLabel.layer.backgroundColor = UIColor(red: 200/255, green: 0, blue: 0, alpha: 1.0).cgColor
        })
    }
    
    func paintBlackColor(){
        UIView.animate(withDuration: 0.25, delay: 0.0, animations: {
            self.s_SymbolLabel.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50).cgColor
        })
        

        
    }
    
    func addEffectToObjects(){
        s_SymbolLabel.layer.shadowOpacity   = 0.6
        s_SymbolLabel.layer.shadowOffset    = CGSizeFromString("2")
        s_SymbolLabel.layer.shadowRadius    = 4
        s_SymbolLabel.layer.masksToBounds   = false
        
        s_PctChange.layer.cornerRadius      = 4
        s_SymbolLabel.layer.cornerRadius    = 4
        
        s_Reset.layer.shadowOpacity         = 0.2
        s_Reset.layer.shadowOffset          = CGSizeFromString("1")
        s_Reset.layer.shadowRadius          = 2
        s_Reset.layer.masksToBounds         = false
        s_Reset.layer.cornerRadius          = 4
        
    }
    func paintViewBlackColor(){
//        UIView.animate(withDuration: 0.25, delay: 0.0, animations: {
  //          self.view.layer.backgroundColor = UIColor.black.cgColor
    //    })
        
        
        //let imageView = UIImageView(frame: self.view.bounds)
        //imageView.image = UIImage(named: "AppBackground")
        //self.view.addSubview(imageView)
        
       //Tealgreen - Fitbit color
        /* let topColor  = UIColor(red:(85/255.0), green:(225/255.0), blue:(225/255.0), alpha: 1.0)
         
         let middleColor  = UIColor(red:(85/255.0), green:(187/255.0), blue:(187/255.0), alpha: 1.0)
         
         let bottomColor = UIColor(red:(15/255.0), green:(115/255.0), blue:(115/255.0), alpha: 1.0)
         */
        let topColor     = UIColor(red:(225/255.0), green:(225/255.0), blue:(225/255.0), alpha: 1.0)
        
        let middleColor  = UIColor(red:(51/255.0), green:(153/255.0), blue:(255/255.0), alpha: 1.0)
       
        let bottomColor  = UIColor(red:(0/255.0), green:(76/255.0), blue:(153/255.0), alpha: 1.0)
        
        let gradientColors:[CGColor] = [topColor.cgColor, middleColor.cgColor, bottomColor.cgColor]
        let gradientLocations:[Float] = [0.3,0.65, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 1)
        
        
        
        self.view.addSubview(s_SymbolLabel)
        self.view.addSubview(s_PctChange)
        self.view.addSubview(s_Price)
        self.view.addSubview(s_UnlikedCounter)
        self.view.addSubview(s_LikedCounter)
        self.view.addSubview(s_LoadPrevSymbol)
        self.view.addSubview(s_LoadNextSymbol)
        self.view.addSubview(s_UnlikeButton)
        self.view.addSubview(s_LikeButton)
        self.view.addSubview(s_SymbolNotes1)
        
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "AppBackground")!)
        //self.view.contentMode = UIViewContentMode.scaleAspectFit
        //self.view.clipsToBounds = true
        //self.view.center = view.center
    }
    
    func paintPctChangeRedColor(){
        UIView.animate(withDuration: 0.25, delay: 0.0, animations: {
        self.s_PctChange.layer.backgroundColor = UIColor(red: 200/255, green: 0, blue: 0, alpha: 1.0).cgColor})
    }
    
    
    func paintPctChangeGreenColor(){
        UIView.animate(withDuration: 0.25, delay: 0.0, animations: {
            self.s_PctChange.layer.backgroundColor = UIColor(red: 0, green: 185/255, blue: 0, alpha: 0.70).cgColor})
    }
    
    func paintPctChangeBlackColor(){
        UIView.animate(withDuration: 0.25, delay: 0.0, animations: {
            self.s_PctChange.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor})
    }
    
    
    func addUnicodeToButtons(){
        s_LoadPrevSymbol.setTitle(NSString(string: "\u{25C0}\u{0000FE0E}") as String, for: .normal)
        
        s_LoadNextSymbol.setTitle(NSString(string: "\u{25B6}\u{0000FE0E}") as String, for: .normal)
    }
    
    
    func usePanGesture(){
        s_SymbolLabel.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanSwipes) )
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        
        s_SymbolLabel.addGestureRecognizer(panGesture)
        
    }
    

    func handlePanSwipes(sender: UIPanGestureRecognizer){
        let dragVelocity            = sender.velocity(in: s_SymbolLabel)
        var considerableDrag:Bool   = false
        var swipePositive:Bool      = false
        var dragTollerance = lastDragVelocity.x/5
        
        NSLog("dragVelocity.x       = \(dragVelocity.x) ")
        NSLog("lastDragVelocity.x   = \(lastDragVelocity.x)")
        NSLog("dragTollerance       = \(dragTollerance)")
        
        if ( (dragVelocity.x +   dragTollerance) > 0) {
            swipePositive       = true
            considerableDrag    = true
        }
        else if ((dragVelocity.x -  dragTollerance) < 0) {
            swipePositive       = false
            considerableDrag    = true
        }
        
        if(considerableDrag){
        switch (sender.state){
            
        case UIGestureRecognizerState.began:
            NSLog("Drag Started")
            break
            
        case UIGestureRecognizerState.cancelled:
            NSLog("Drag Cancelled")
            paintBlackColor()
            break
            
        case UIGestureRecognizerState.changed:
            
            if(swipePositive){
                paintGreenColor()
            }
            else{
                paintRedColor()
            }
            break
        
        case UIGestureRecognizerState.ended:
            NSLog("Drag ended")
            performAction(likeStock: swipePositive)
            getSymbol(isNextSymbol: true)
 
            
            break
            
        case UIGestureRecognizerState.failed:
            NSLog("Drag Failed")
            paintBlackColor()
            break
        
        default:
            break
        }
        }
        else {NSLog("Insignificant Drage  - ")}
        lastDragVelocity = dragVelocity
  
    }
   
    func moveLabel(sender: UIPanGestureRecognizer, positiveDirection: Bool){
        
        var transaction = sender.translation(in: s_SymbolLabel)
        NSLog("transaction.x = \(transaction.x)")
        NSLog("s_SymbolLabel.center.x = \(s_SymbolLabel.center.x)")
        transaction.x = transaction.x/10
        if (positiveDirection) {
        s_SymbolLabel.center = CGPoint(x: s_SymbolLabel.center.x + transaction.x, y: s_SymbolLabel.center.y )
        } else { s_SymbolLabel.center = CGPoint(x: s_SymbolLabel.center.x + transaction.x, y: s_SymbolLabel.center.y )}
        
    }
 
    func getNextSymbol(goNextSymbol: AnyObject){
        NSLog("Before: Count = \(count)")
        NSLog("goNextSymbol = \(goNextSymbol)")
        
        let param = Int(goNextSymbol as! NSNumber)
        
        if (param == 1 ){
            self.count += 1
            if (self.count >= GLOBAL_TICKERS.count){self.count = 0}
        }
        else {
            if (self.count == 0){self.count = GLOBAL_TICKERS.count-1}
            else {self.count -= 1}
        }
        
        let tempSymbol:Symbol = GLOBAL_TICKERS[self.count]
        self.s_SymbolLabel.text = tempSymbol.Name
        self.s_Price.text       = tempSymbol.Price?.description
        var newsString:String   = ""
        var totalNews = tempSymbol.SymbolNews?.count
       
/*
         for counter in 0 ..< totalNews {
            newsString += (tempSymbol.SymbolNews?[counter])!
        }
*/
        
        
        
        if (tempSymbol.PriceIncreased)!{
            self.s_PctChange.text = "+" +  (tempSymbol.PctChange?.description)! + "%"
            self.paintPctChangeGreenColor()
        } else{
            self.s_PctChange.text = "-" +  (tempSymbol.PctChange?.description)! + "%"
            self.paintPctChangeRedColor()
        }
        if (tempSymbol.Touched)!
        {
            if (tempSymbol.PreviouslyLiked)! {
                self.paintGreenColor()
            } else {
                self.paintRedColor()}
        }
        else {
            self.paintBlackColor()
        }
        NSLog("After: Count = \(count)")
    }
    
    func getSymbol(isNextSymbol: Bool, didOriginateFromButtons: Bool = false){
        NSLog("isNextSymbol = \(isNextSymbol)")
        let param:Bool = isNextSymbol
        var delay = 0.0
        NSLog("didOriginateFromButtons = \(didOriginateFromButtons)")
        if (!didOriginateFromButtons){
            delay = 0.5
        }
        
        perform(#selector(getNextSymbol(goNextSymbol:)), with: param, afterDelay: delay)
        
    }

    
    
    func performAction(likeStock:Bool){
        GLOBAL_TICKERS[count].Touched           = true
        GLOBAL_TICKERS[count].PreviouslyLiked   = likeStock
        
        if likeStock == true {
            let found = GLOBAL_LIKE_STOCK.index(where: {$0 == s_SymbolLabel.text!})

            if (found == nil){
                GLOBAL_LIKE_STOCK.append(s_SymbolLabel.text!)
            }
            GLOBAL_DISLIKE_STOCK.index(of: s_SymbolLabel.text!).map{GLOBAL_DISLIKE_STOCK.remove(at: $0)}
        }
        else
        {
            let found = GLOBAL_DISLIKE_STOCK.index(where: {$0 == s_SymbolLabel.text!})
            
            if (found == nil){
                GLOBAL_DISLIKE_STOCK.append(s_SymbolLabel.text!)
            }
            GLOBAL_LIKE_STOCK.index(of: s_SymbolLabel.text!).map{GLOBAL_LIKE_STOCK.remove(at: $0)}
        }
        s_LikedCounter.text     = String(GLOBAL_LIKE_STOCK.count)
        s_UnlikedCounter.text   = String(GLOBAL_DISLIKE_STOCK.count)
 }
    
    
    func performResetAction(){
        GLOBAL_TICKERS[count].Touched           = false
        GLOBAL_TICKERS[count].PreviouslyLiked   = false
        
        GLOBAL_DISLIKE_STOCK.index(of: s_SymbolLabel.text!).map{GLOBAL_DISLIKE_STOCK.remove(at: $0)}
        
        GLOBAL_LIKE_STOCK.index(of: s_SymbolLabel.text!).map{GLOBAL_LIKE_STOCK.remove(at: $0)}
        
        s_LikedCounter.text     = String(GLOBAL_LIKE_STOCK.count)
        s_UnlikedCounter.text   = String(GLOBAL_DISLIKE_STOCK.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

