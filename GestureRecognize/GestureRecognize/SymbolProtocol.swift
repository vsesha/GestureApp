//
//  SymbolProtocol.swift
//  GestureRecognize
//
//  Created by Vasudevan Seshadri on 7/6/17.
//  Copyright © 2017 Vasudevan Seshadri. All rights reserved.
//

import Foundation


struct Symbol {
    var Name:               String?
    var Price:              Double?
    var PctChange:          Float?
    var PriceIncreased:     Bool?
    var Touched:            Bool?
    var PreviouslyLiked:    Bool?
    var SymbolNews:         [String]?
    
    
    init (_Name:String, _Price:Double, _PctChange:Float, _PriceIncreased: Bool, _Touched:Bool, _PreviouslyLiked:Bool, _SymbolNews:[String])
    {
        Name            = _Name
        Price           = _Price
        PctChange       = _PctChange
        PriceIncreased  = _PriceIncreased
        Touched         = _Touched
        PreviouslyLiked = _PreviouslyLiked
        SymbolNews      = _SymbolNews
        
    }
}


