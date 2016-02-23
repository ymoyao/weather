//
//  RootViewController.swift
//  Weather
//
//  Created by SR on 16/2/1.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
//        let left = UIBarButtonItem.init(image: UIImage.init(named: "navBarBlk"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnClick"))
        
        let left = UIBarButtonItem.init(image: UIImage.init(named: "btn_close"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("btnClick"))
        self.navigationItem.leftBarButtonItem = left
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnClick() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
