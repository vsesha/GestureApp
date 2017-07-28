//
//  GlobalFunctions.swift
//  GestureRecognize
//
//  Created by Vasudevan Seshadri on 7/6/17.
//  Copyright © 2017 Vasudevan Seshadri. All rights reserved.
//

import Foundation
func GLOBAL_INITILIZE() {
    var news:[String] = []
    
    news.append("InvestorsObserver releases covered-call reports for Apple, Facebook, Snap Inc., Squar...")
    news.append("Stocks Under Scanner in the Electronic Equipment Space -- Apple, Koninklijke Philips,...")
    
    news.append("Cryptocurrency Advancements and Blockchain Technology Go Mainstream Creating Innovati...")
    
    news.append("Riskified Announces $33 Million Growth Round Funding Led By Pitango Growth, With Part...")
    
    var symbolData = Symbol(_Name: "APPL", _Price: 128.31, _PctChange: 0.03, _PriceIncreased: true, _Touched: false, _PreviouslyLiked: false, _SymbolNews: news)
    GLOBAL_TICKERS.append(symbolData)
    news.removeAll()
   
    
    news.append("Sustained investment in Albany's Network leads to 3rd Party Win for Verizon")
    news.append("Verizon validates NG-PON2 interoperability based on OpenOMCI specification")
    
    news.append("Cryptocurrency Advancements and Blockchain Technology Go Mainstream Creating Innovati...")
    
    news.append("Riskified Announces $33 Million Growth Round Funding Led By Pitango Growth, With Part...")
    symbolData = Symbol(_Name: "VZ", _Price: 12.34, _PctChange: 0.06, _PriceIncreased: true, _Touched: false, _PreviouslyLiked: false, _SymbolNews: news)
    GLOBAL_TICKERS.append(symbolData)
    news.removeAll()
    
    
    
    symbolData = Symbol(_Name: "TWTR", _Price: 87.52, _PctChange: 0.20, _PriceIncreased: true, _Touched: false, _PreviouslyLiked: false, _SymbolNews: news)
    GLOBAL_TICKERS.append(symbolData)
    
    symbolData = Symbol(_Name: "JPM", _Price: 44.06, _PctChange: 0.01, _PriceIncreased: false, _Touched: false, _PreviouslyLiked: false, _SymbolNews: news)
    GLOBAL_TICKERS.append(symbolData)
    
    symbolData = Symbol(_Name: "AMZN", _Price: 73.34, _PctChange: 0.05, _PriceIncreased: true, _Touched: false, _PreviouslyLiked: false, _SymbolNews: news)
    GLOBAL_TICKERS.append(symbolData)
    
    symbolData = Symbol(_Name: "MSFT", _Price: 101.39, _PctChange: 0.01, _PriceIncreased: false, _Touched: false, _PreviouslyLiked: false, _SymbolNews: news)
    GLOBAL_TICKERS.append(symbolData)
    
    symbolData = Symbol(_Name: "GOOGL", _Price: 112.36, _PctChange: 0.50, _PriceIncreased: true, _Touched: false, _PreviouslyLiked: false, _SymbolNews: news)
    GLOBAL_TICKERS.append(symbolData)
    
    symbolData = Symbol(_Name: "NFLX", _Price: 41.31, _PctChange: 0.25, _PriceIncreased: false, _Touched: false, _PreviouslyLiked: false, _SymbolNews: news)
    GLOBAL_TICKERS.append(symbolData)
    
}
