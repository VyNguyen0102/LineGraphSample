//
//  ViewController.swift
//  LineGraphSample
//
//  Created by Vy Nguyen on 12/25/18.
//  Copyright © 2018 VVLab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mGraphView: LineGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lineColors = [UIColor.red, UIColor.green, UIColor.blue]
        var graphData: [GraphItem] = []
        for i in 0...19 {
            var itemValue: [GraphItemPoint] = []
            for y in 0..<3 {
                let item = GraphItemPoint.init(itemID: y, value: CGFloat(getRandomNumberBetween(5, to: 18)))
                itemValue.append(item)
            }
            let graphItem = GraphItem(stringLabel: "Label \(i)", valueArray: itemValue)
            graphData.append(graphItem)
        }
        mGraphView.lineColors = lineColors
        mGraphView.graphValues = graphData
    }
    
    func getRandomNumberBetween(_ from: Int, to: Int) -> Int {
        return from + Int(arc4random()) % (to - from + 1)
    }


}

