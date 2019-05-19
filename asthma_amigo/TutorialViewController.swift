//
//  TutorialViewController.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 12/5/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//



/*
 Code for implementing PageController and page control tab has been contributed from this tutorial:
 https://www.youtube.com/watch?v=RVAtqQ8CyKM
 */

import UIKit

class TutorialViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    
    //stores the correct order in which the view controllers will be displayed.
    lazy var viewControllerList: [UIViewController] = {
        return [self.newLandView(viewController: "tute1"),
                self.newLandView(viewController: "tute2"),
                self.newLandView(viewController: "tute3")]
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        navigationController?.navigationBar.backgroundColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
    }
    
    var pageControl = UIPageControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstViewController = viewControllerList.first{
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        self.delegate = self
        configurePageControl()
        
        // Do any additional setup after loading the view.
    }
    
    func configurePageControl(){
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = viewControllerList.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor(red: 66/255, green: 83/255, blue: 108/255, alpha: 1)
        self.view.addSubview(pageControl)
        
    }
    
    //returns a viewcontroller to be displayed from the main storyboard.
    func newLandView(viewController: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:viewController)
    }
    
    //for swiping back from left to right.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerList.index(of: viewController) else{
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else{
            //for contiuous page scroll, uncomment the next line
            //return viewControllerList.last
            
            //page stops at the end
            return nil
        }
        
        guard viewControllerList.count > previousIndex else {
            return nil
        }
        
        return viewControllerList[previousIndex]
    }
    
    //swiping forward from right to left.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerList.index(of: viewController) else{
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard viewControllerList.count != nextIndex else{
            //for contiuous page scroll, uncomment the next line
            //return viewControllerList.first
            
            //page stops at end
            return nil
        }
        
        guard viewControllerList.count > nextIndex else {
            return nil
        }
        
        return viewControllerList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = viewControllerList.index(of: pageContentViewController)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

