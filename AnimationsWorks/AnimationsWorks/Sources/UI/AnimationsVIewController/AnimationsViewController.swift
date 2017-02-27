//
//  AnimationsViewController.swift
//  AnimationsWorks
//
//  Created by Pavel Bondar on 2/22/17.
//  Copyright © 2017 Pavel Bondar. All rights reserved.
//

import UIKit

class AnimationsViewController: UIViewController {
    var animView: AnimationsView?
    
    //MARK: -
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animView = viewGetter()
    }
    
    @IBAction func onLeftButton(_ sender: Any) {
        print("left button pressed")
    }
    
    @IBAction func onRightButton(_ sender: Any) {
        print("right button pressed")
    }
}
