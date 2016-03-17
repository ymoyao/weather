//
//  MyTabBarController.swift
//  Weather
//
//  Created by SR on 16/1/28.
//  Copyright © 2016年 游辉. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //添加vc到tab
        addViewControllerToTab()
        
        //定制tabBar
        customTabBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        //添加vc到tab
//        addViewControllerToTab()
//        
//        //定制tabBar
//        customTabBar()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 添加vc到tab
    func addViewControllerToTab() {
        var narMutArray = [UIViewController]()
        let vcArray = [MainViewController() ,HealthViewController(),DiaryViewController() ]

        for controller:UIViewController in vcArray {
            let nav = UINavigationController.init(rootViewController: controller )
            nav.navigationBarHidden = true
            narMutArray.append(nav)
        }
        self.viewControllers = narMutArray
    }
    
    //MARK: - 定制tabBar
    func customTabBar() {
        let tabBar = MyTabBar.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 49))
        tabBar.tabClosure = { (tag) in
            self.selectedIndex = tag
        }
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
