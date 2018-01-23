import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var pauseButton: UIButton!

    private var applicationWillEnterForegroundNotification: NSObjectProtocol?
    private var applicationDidEnterBackgroundNotification: NSObjectProtocol?

    override func viewDidLoad() {
        circleView.layer.cornerRadius = circleView.frame.height / 2
        applicationWillEnterForegroundNotification = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: .main) { (_) in
            self.addTrasnformScaleAnimation()
        }

        applicationDidEnterBackgroundNotification = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationDidEnterBackground, object: nil, queue: .main) { (_) in
            self.removeAnimations()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTrasnformScaleAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeAnimations()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(applicationWillEnterForegroundNotification as Any)
        NotificationCenter.default.removeObserver(applicationDidEnterBackgroundNotification as Any)
    }

    @IBAction func userTappedPauseButton(_ sender: Any) {
        if circleView.layer.speed == 0 {
            resumeAnimation()
        } else {
            pauseAnimation()
        }
    }

    private func addTrasnformScaleAnimation() {
        let transformScaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        transformScaleAnimation.fromValue = 1
        transformScaleAnimation.toValue = 1.1
        transformScaleAnimation.autoreverses = true
        transformScaleAnimation.repeatCount = .infinity
        transformScaleAnimation.duration = 1.5
        transformScaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        circleView.layer.add(transformScaleAnimation, forKey: "transform.scale")
    }

    private func removeAnimations() {
        circleView.layer.removeAllAnimations()
    }

    private func pauseAnimation() {
        circleView.layer.pauseAnimation()
        self.pauseButton.setTitle("Resume", for: .normal)
    }

    private func resumeAnimation() {
        circleView.layer.resumeAnimation()
        self.pauseButton.setTitle("Pause", for: .normal)
    }

}

extension CALayer {
    func pauseAnimation() {
        let pausedTime: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0.0
        self.timeOffset = pausedTime
    }

    func resumeAnimation() {
        let pausedTime: CFTimeInterval = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }
}
