//
//  ViewController.swift
//  RotationView
//
//  Created by Aoi SHIRATORI on 08/23/2022.
//  Copyright (c) 2022 Aoi SHIRATORI. All rights reserved.
//

import UIKit
import RotationView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let v = RotationView(functionList: [1,2,3,0], cornerSize: 60)
        v.frame = CGRect(x: 50, y: 100, width: 100, height: 200)
        view.addSubview(v)

        v.viewCorners.forEach() {
            $0.backgroundColor = .blue
        }

        v.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.25)
        v.isShownCorner = true
        v.backgroundColor = .red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

