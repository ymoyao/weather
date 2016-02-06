//
//  MyTabBarController.swift
//  Weather
//
//  Created by SR on 16/1/28.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加vc到tab
        addViewControllerToTab()
        
        //定制tabBar
        customTabBar()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 添加vc到tab
    func addViewControllerToTab() {
        var narMutArray = [UIViewController]()
        let vcArray = [MainViewController() ,DetailViewController(),PersonViewController()]

        for controller:UIViewController in vcArray {
            let nav = UINavigationController.init(rootViewController: controller )
            narMutArray.append(nav)
        }
        self.viewControllers = narMutArray
    }
    
    //MARK: - 定制tabBar
    func customTabBar() {
        let tabBar = MyTabBar.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 49))
        self.tabBar.addSubview(tabBar)
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
