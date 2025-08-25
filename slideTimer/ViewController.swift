//
//  ViewController.swift
//  slideTimer
//
//  Created by LARRY COMBS on 1/21/18.
//  Copyright © 2018 LARRY COMBS. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class ViewController: UIViewController, CountdownTimerDelegate {
    
    
    
    //MARK - Outlets
    @IBOutlet weak var History: UIBarButtonItem!
    @IBAction func History(_ sender: Any) {
        
        
    }
    
    @IBOutlet weak var Reset: UIBarButtonItem!
    @IBAction func Reset(_ sender: Any) {
        
        sliderHoursOutlet.isHidden = false
        sliderMinutesOutlet.isHidden = false
        sliderSecondsOutlet.isHidden = false
        messageLabel.isHidden = true
        counterView.isHidden = false
        
        stopBtn.isEnabled = false
        stopBtn.alpha = 1.0
        Reset.isEnabled = true
        startBtn.setTitle("START",for: .normal)
        
        
    }
    @IBOutlet weak var sliderHoursOutlet: UISlider!
    
    @IBAction func sliderHoursAction(_ sender: UISlider)
    {
        let value = Int(sender.value)
        selectedHours = value
        hours.text = String(value)
        countdownTimer.duration = Double(sender.value)
        countdownTimer.setTimer(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSecs)
        progressBar.setProgressBar(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSecs)
       
    }
    @IBOutlet weak var sliderMinutesOutlet: UISlider!
    @IBAction func sliderMinutesAction(_ sender: UISlider)
    {
        let value = Int(sender.value)
        selectedMinutes = value
        minutes.text = String(value)
        countdownTimer.setTimer(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSecs)
        progressBar.setProgressBar(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSecs)
        
 
    }
    @IBOutlet weak var sliderSecondsOutlet: UISlider!
    @IBAction func sliderSecondsAction(_ sender: UISlider)
    {
        selectedSecs = Int(sender.value)
        //countdownTimer.duration = Double(sender.value)
        seconds.text? = String(selectedSecs)
        countdownTimer.setTimer(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSecs)
        progressBar.setProgressBar(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSecs)
        
    }
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var seconds: UILabel!
    @IBOutlet weak var counterView: UIStackView!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    
    
    
    //MARK - Vars
    
    var countdownTimerDidStart = false
    var soundEffect: AVAudioPlayer = AVAudioPlayer()
    
    lazy var countdownTimer: CountdownTimer = {
        let countdownTimer = CountdownTimer()
        return countdownTimer
    }()
    

    
    
    // MARK - Slider Load Setup 
    var selectedSecs = 30
    var selectedMinutes = 0
    var selectedHours = 0
    
    let picker = UIDatePicker()
    
    
    
    lazy var messageLabel: UILabel = {
        let label = UILabel(frame:CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.light)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Done!"
        
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //randomColor()
        
       
        func generateRandomPastelColor(withMixedColor mixColor: UIColor?) -> UIColor {
            // Randomly generate number in closure
            let randomColorGenerator = { ()-> CGFloat in
                CGFloat(arc4random() % 256 ) / 256
            }
            
            var red: CGFloat = randomColorGenerator()
            var green: CGFloat = randomColorGenerator()
            var blue: CGFloat = randomColorGenerator()
            
            // Mix the color
            if let mixColor = mixColor {
                var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0;
                mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)
                
                red = (red + mixRed) / 2;
                green = (green + mixGreen) / 2;
                blue = (blue + mixBlue) / 2;
            }
            
            return UIColor(red: red, green: green, blue: blue, alpha: 0.5)
        
        }
        
        view.backgroundColor = generateRandomPastelColor(withMixedColor: randomColor())
        
        
        
        countdownTimer.delegate = self
        countdownTimer.setTimer(hours: 0, minutes: 0, seconds: selectedSecs)
        progressBar.setProgressBar(hours: 0, minutes: 0, seconds: selectedSecs)
        stopBtn.isEnabled = false
        stopBtn.alpha = 0.5
        Reset.isEnabled = false
        view.addSubview(messageLabel)
        
        var constraintCenter = NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: self.minutes, attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addConstraint(constraintCenter)
        constraintCenter = NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self.minutes, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(constraintCenter)
        
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, YYYY"
        let stringDate = dateFormatter.string(from: date as Date)
        Date.text = stringDate
        
        messageLabel.isHidden = true
        counterView.isHidden = false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - Countdown Timer Delegate
    
    func countdownTime(time: (hours: String, minutes: String, seconds: String)) {
        hours.text = time.hours
        minutes.text = time.minutes
        seconds.text = time.seconds
    }
    
    
    func countdownTimerDone() {
        
        sliderHoursOutlet.isHidden = false
        sliderMinutesOutlet.isHidden = false
        sliderSecondsOutlet.isHidden = false
        counterView.isHidden = true
        messageLabel.isHidden = false
        seconds.text = String(selectedSecs)
        countdownTimerDidStart = false
        stopBtn.isEnabled = false
        stopBtn.alpha = 0.5
        startBtn.setTitle("START",for: .normal)
        Reset.isEnabled = true
        
       
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        let musicFile = Bundle.main.path(forResource: "SystemSoundID", ofType: ".mp3")
        do {
            try soundEffect = AVAudioPlayer(contentsOf: URL (fileURLWithPath: musicFile!))
        }
        catch{
            
            print(error)
        }
        
        soundEffect.play()
        
        // Start confetti animation
        startConfettiAnimation()
            
        print("countdownTimerDone")
    }
    
    
    //MARK: - Actions
    
    @IBAction func startTimer(_ sender: UIButton) {
        
        sliderHoursOutlet.isHidden = true
        sliderMinutesOutlet.isHidden = true
        sliderSecondsOutlet.isHidden = true
        messageLabel.isHidden = true
        counterView.isHidden = false
        
        stopBtn.isEnabled = true
        stopBtn.alpha = 1.0
        Reset.isEnabled = false
        
        let string = hours.text! + ":" + minutes.text! + ":" + seconds.text!
        SlideTimerUserDefaults().add(entry: string)
        
        // Set progessBar and countdownTimer
        
        if !countdownTimerDidStart{
            countdownTimer.start()
            progressBar.start()
            countdownTimerDidStart = true
            startBtn.setTitle("PAUSE",for: .normal)
            
        }else{
            countdownTimer.pause()
            progressBar.pause()
            countdownTimerDidStart = false
            startBtn.setTitle("RESUME",for: .normal)
        }
    }
    
    
    @IBAction func stopTimer(_ sender: UIButton) {
        
        resetTimer()
    }
    
    func resetTimer(){
        
        sliderHoursOutlet.isHidden = false
        sliderMinutesOutlet.isHidden = false
        sliderSecondsOutlet.isHidden = false
        countdownTimer.stop()
        progressBar.stop()
        countdownTimerDidStart = false
        stopBtn.isEnabled = false
        stopBtn.alpha = 0.5
        startBtn.setTitle("START",for: .normal)
        Reset.isEnabled = false
        
        
    }
    

    func randomColor() -> UIColor {
        
        let redValue = CGFloat(arc4random_uniform(256))/256.0
        let blueValue = CGFloat(arc4random_uniform(256))/256.0
        let greenValue = CGFloat(arc4random_uniform(256))/256.0
        return UIColor (red: redValue, green: greenValue, blue: blueValue, alpha: 0.5)
    }

    func countArray (){
       // print(count)
        
    }
    
    // MARK: - Confetti Animation
    
    private func startConfettiAnimation() {
        // Create multiple confetti pieces
        for _ in 0..<50 {
            createConfettiPiece()
        }
        
        // Remove confetti after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.removeConfetti()
        }
    }
    
    private func createConfettiPiece() {
        let confettiPiece = UIView()
        confettiPiece.translatesAutoresizingMaskIntoConstraints = false
        
        // Random size for confetti pieces
        let size = CGFloat.random(in: 4...12)
        confettiPiece.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        // Random color from our custom colors
        confettiPiece.backgroundColor = getRandomConfettiColor()
        
        // Random shape (square, circle, or diamond)
        let shape = Int.random(in: 0...2)
        switch shape {
        case 0: // Square
            confettiPiece.layer.cornerRadius = 0
        case 1: // Circle
            confettiPiece.layer.cornerRadius = size / 2
        case 2: // Diamond
            confettiPiece.transform = CGAffineTransform(rotationAngle: .pi / 4)
        default:
            break
        }
        
        confettiPiece.tag = 999 // Tag for easy removal
        view.addSubview(confettiPiece)
        
        // Position at bottom of screen
        let screenWidth = view.bounds.width
        let randomX = CGFloat.random(in: 0...screenWidth)
        confettiPiece.center = CGPoint(x: randomX, y: view.bounds.height + 20)
        
        // Animate confetti
        animateConfettiPiece(confettiPiece)
    }
    
    private func animateConfettiPiece(_ piece: UIView) {
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        
        // Random final position
        let finalX = CGFloat.random(in: -50...screenWidth + 50)
        let finalY = screenHeight + 100
        
        // Random peak height (shoot up from bottom)
        let peakHeight = CGFloat.random(in: screenHeight * 0.3...screenHeight * 0.8)
        
        // Create path for confetti movement
        let path = UIBezierPath()
        path.move(to: piece.center)
        
        // Control points for curved path (shoot up then fall)
        let controlPoint1 = CGPoint(x: piece.center.x + CGFloat.random(in: -100...100), y: piece.center.y - peakHeight * 0.5)
        let controlPoint2 = CGPoint(x: finalX + CGFloat.random(in: -50...50), y: piece.center.y - peakHeight * 0.3)
        
        path.addCurve(to: CGPoint(x: finalX, y: finalY), controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        // Create animation
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = Double.random(in: 3.0...5.0) // Slow fall
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        // Add rotation animation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Double.pi * 2 * Double.random(in: 1...3)
        rotationAnimation.duration = animation.duration
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Add scale animation (slight bounce effect)
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.values = [1.0, 1.2, 0.8, 1.0]
        scaleAnimation.keyTimes = [0.0, 0.3, 0.7, 1.0]
        scaleAnimation.duration = animation.duration
        
        // Group animations
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation, rotationAnimation, scaleAnimation]
        groupAnimation.duration = animation.duration
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.isRemovedOnCompletion = false
        
        piece.layer.add(groupAnimation, forKey: "confettiAnimation")
        
        // Update final position
        piece.center = CGPoint(x: finalX, y: finalY)
    }
    
    private func getRandomConfettiColor() -> UIColor {
        let colors: [UIColor] = [
            CustomColor.strawberry,
            CustomColor.aquaBlue,
            CustomColor.lime,
            CustomColor.lemon,
            CustomColor.summerSky,
            CustomColor.orange,
            CustomColor.coral,
            CustomColor.peach,
            CustomColor.amber,
            CustomColor.gold,
            CustomColor.turquoise,
            CustomColor.cyan,
            CustomColor.violet,
            CustomColor.lavender,
            CustomColor.emerald,
            CustomColor.mint,
            CustomColor.chartreuse,
            CustomColor.roseGold,
            CustomColor.electricBlue,
            CustomColor.neonGreen,
            CustomColor.hotPink,
            CustomColor.fuchsia,
            CustomColor.magenta,
            CustomColor.pastelPink,
            CustomColor.pastelBlue,
            CustomColor.pastelGreen,
            CustomColor.pastelYellow,
            CustomColor.pastelPurple,
            CustomColor.pastelOrange
        ]
        
        return colors.randomElement() ?? CustomColor.strawberry
    }
    
    private func removeConfetti() {
        // Remove all confetti pieces from the view
        for subview in view.subviews {
            if subview.tag == 999 { // We'll use tag 999 for confetti pieces
                subview.removeFromSuperview()
            }
        }
    }
    
    
    
}
