//
//  ViewController+Extension.swift
//  SkillsTracker
//
//  Created by Ashlesha Kamble on 10/06/22.
//

import Foundation
import UIKit

//MARK: Alert View Controller

extension UIViewController{
    
    public func openAlert(title: String,
                          message: String,
                          alertStyle: UIAlertController.Style,
                          actionTitles: [String],
                          actionStyles: [UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated(){
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        self.present(alertController, animated: true)
    }
}

extension UIViewController {
    func keyboardTaparound() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
   @objc func dismissKeyboard() {
       view.endEditing(true)
    }
}
 var theView: UIView?
extension UIViewController {
    func showSpinner() {
        theView = UIView(frame: self.view.bounds)
        //theView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        //let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = UIColor.systemTeal
        activityIndicator.center = theView!.center
        activityIndicator.startAnimating()
        theView?.addSubview(activityIndicator)
        self.view.addSubview(theView!)
    }
    
    func removeSpinner () {
        theView?.removeFromSuperview()
        theView = nil
    }
    
}

