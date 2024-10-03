//
//  BaseViewController.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import UIKit
import Combine
import Lottie

class BaseViewController: UIViewController { 
    var cancellables = Set<AnyCancellable>()
    
    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoader()
    }
    
    deinit {
        animationView = nil
    }
}

private extension BaseViewController {
    func setupLoader() {
        animationView = .init(name: "loader_animation")
        animationView?.frame = view.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 0.5
        view.addSubview(animationView!)
    }
}

extension BaseViewController {
    
    func showLoader(_ shouldShow: Bool) {
        shouldShow == true ? animationView?.play() : animationView?.pause()
        animationView?.isHidden = shouldShow == false
    }
}
