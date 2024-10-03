//
//  AppDelegate.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let feedViewFactory = FeedViewFactory(networkService: FeedNetworkService())
        let feedViewController = feedViewFactory.makeFeedView()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: feedViewController)
        window?.makeKeyAndVisible()
        
        return true
    }
}

