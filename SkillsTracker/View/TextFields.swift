//
//  TextFields.swift
//  SkillsTracker
//
//  Created by Ashlesha Kamble on 09/06/22.
//

import UIKit

//MARK: Customized Text Fields

class TextFields: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        customTextField()
    }
    
    func customTextField() {
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = .darkGray
        addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            underlineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

}

