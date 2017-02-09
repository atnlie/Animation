//
//  SimpleAnimationVC
//  Animation
//
//  Created by Atnlie on 2/9/17.
//  Copyright © 2017 Atnlie. All rights reserved.
//

import UIKit

class SimpleAnimationVC: UIViewController {
    var lingkaran : CGPoint!
    var animasiLingkaran : UIViewPropertyAnimator!
    let durasiAnimasi = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCircle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - Create Circle
    func createCircle(){
        let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        circle.center = self.view.center
        circle.layer.cornerRadius = circle.layer.frame.width/2
        circle.backgroundColor = UIColor.red
        
        animasiLingkaran = UIViewPropertyAnimator(duration: durasiAnimasi, curve: .easeInOut, animations: {
            [unowned circle] in
            circle.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        })
        circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.drag)))
        self.view.addSubview(circle)
    }

    func drag(gesture: UIPanGestureRecognizer){
        let target = gesture.view!
        
        switch gesture.state {
        //case .began, .ended:
        case .began:
            lingkaran = target.center

            let durationFactor = animasiLingkaran.fractionComplete
            
            if animasiLingkaran.state == .active {
                animasiLingkaran.stopAnimation(true)
            }
            
            if gesture.state == .began {
                animasiLingkaran.addAnimations {
                    target.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                }
            }else{
                animasiLingkaran.addAnimations {
                    target.transform = CGAffineTransform.identity
                }
            }
            
            animasiLingkaran.startAnimation()
            animasiLingkaran.pauseAnimation()
            animasiLingkaran.continueAnimation(withTimingParameters: nil, durationFactor: durationFactor)
            
        case .changed:
            let translation = gesture.translation(in: self.view)
            target.center = CGPoint(x: lingkaran.x + translation.x, y: lingkaran.y + translation.y)
        case .ended:
            let velo = gesture.velocity(in: target)
            let velocity = CGVector(dx: velo.x/500, dy: velo.y/500)
            let springParameters = UISpringTimingParameters(mass: 2.5, stiffness: 70, damping: 55, initialVelocity: velocity)
            animasiLingkaran = UIViewPropertyAnimator(duration: 0.0, timingParameters: springParameters)
            animasiLingkaran.addAnimations {
                target.center = self.view.center
            }
            animasiLingkaran.startAnimation()
        default:
            break
        }
        print(target.center)
    }
    
   
}

