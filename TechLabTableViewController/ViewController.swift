//
//  ViewController.swift
//  uu
//
//  Created by TECHLAB on 1/4/16.
//  Copyright © 2016 TECHLAB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let cellId = "basicCell"
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var placeholderLabel: UILabel!
    var initialContentSizeHeight : CGFloat = 0.0
    var initialConstantHeight : CGFloat = 0.0
    var hasScrollToBottom = false
    var textFieldShouldBecomeFirstResponder = false
    @IBOutlet weak var inputBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputTextHeightConstraint: NSLayoutConstraint!
    var rows = ["1. C. Ronaldo (R. Madrid) – €210m",
        "2. Messi (Barcelone) – €200m",
        "3. Neymar (Barcelone) – €135m",
        "4. Ibrahimovic (PSG) – €105m",
        "5. Wayne Rooney (Ma. United) – €103m",
        "6. Kaká (Orlando City) – €96m",
        "7. Eto’o (Sampdoria) – €87m",
        "8. Raul (New York Cosmos) – €85m",
        "9. Ronaldinho (Queretaro) – €83m",
        "10. Lampard (M. City) – €80m",
        "11. Schweinsteiger (M. United) – €75m",
        "12. Rio Ferdinand (QPR) – €72m",
        "13. Buffon (Juventus) – €68m",
        "14. Gerrard (Liverpool) – €64m",
        "15. Yaya Touré (M. City) – €62m",
        "16. Ribéry (Bayern Munich) – €61m",
        "17. Totti (Roma) – €60m",
        "18. Piqué (Barcelone) – €58m",
        "19. Agüero (M. City) – €58m",
        "20. John Terry (Chelsea) – €56m"]
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground,object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        textField.delegate = self
        textField.layer.borderColor = UIColor(netHex : 0x230a00).cgColor
        initialConstantHeight = inputTextHeightConstraint.constant
        //Setup place holder label
        placeholderLabel = UILabel()
        placeholderLabel.text = "Votre commentaire"
        placeholderLabel.font = textField.font
        placeholderLabel.sizeToFit()
        textField.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x:5,y: textField.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.isHidden = !textField.text.isEmpty
        
        
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.appWillEnterInForeground(notification:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.appDidBecomeActive(notification:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @IBAction func sendIt(sender: AnyObject) {
        
    }
    func appDidBecomeActive(notification:NSNotification){
        if(textFieldShouldBecomeFirstResponder){
            textField.becomeFirstResponder()
        }
       
    }
    func appWillEnterInForeground(notification:NSNotification){
        if(textField.isFirstResponder){
            textField.resignFirstResponder()
            textFieldShouldBecomeFirstResponder = true
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func keyboardWillChangeFrame(notification:NSNotification){
        //Calculate the keyboard size
        let keyboardEndFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let keyboardBeginFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue
        let animationCurve = UIViewAnimationOptions.init(rawValue: UInt((notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]! as! NSNumber).uint32Value << 16))
        let animationDuration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]! as! Double
        let delta = (keyboardBeginFrame?.origin.y)! - (keyboardEndFrame?.origin.y)!
        // If user has not scrolled down to bottom, change the input bar bottom constraint
        if(!self.hasScrollToBottom){
            self.inputBarBottomConstraint.constant += delta
        }else{
            self.inputBarBottomConstraint.constant = 0
        }
        
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: [animationCurve], animations: { () -> Void in
            if(self.hasScrollToBottom && self.tableView.contentInset.top == 0 && delta > 0){
                //Adjust the scrollView content offset to scroll up when key board appear
                self.scrollView.contentOffset.y += delta
                //Adjust the table view content inset to make rows scrolled up can scroll down
                self.tableView.contentInset.top += delta
            }else{
                //Reset scroll view content offset and table view content inset when the keyboard is hiddn (delta < 0)
                
                self.scrollView.contentOffset.y = 0
                self.tableView.contentInset.top = 0
            }
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    @IBAction func panningTheScrollView(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
}
extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row >= rows.count - 1){
            hasScrollToBottom = true
        }
    }
}
extension ViewController : UITableViewDataSource{
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! TableViewCell
        cell.labelTitle.text = rows[indexPath.row]
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
}
extension ViewController : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        if(initialContentSizeHeight == 0){
            initialContentSizeHeight = textView.contentSize.height
        }
        
        let delta = textView.contentSize.height - initialContentSizeHeight
        initialContentSizeHeight = textView.contentSize.height
        //Increase input bar height
        if(delta + inputTextHeightConstraint.constant > initialConstantHeight){
            inputTextHeightConstraint.constant += delta
        }else{
            inputTextHeightConstraint.constant = initialConstantHeight
        }
        
        
        UIView.animate(withDuration: 0.3, animations: {
            
            if(self.hasScrollToBottom){
                //Adjust the tableView content y Offset to scroll up when the texview grow up or small down
                self.tableView.contentOffset.y += delta
            }
            self.view.layoutIfNeeded()
        })
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
