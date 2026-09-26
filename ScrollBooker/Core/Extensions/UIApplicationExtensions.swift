//
//  UIApplicationExtensions.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.09.2026.
//

import UIKit

extension UIApplication {
    var keyWindowRootViewController: UIViewController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first(where: \.isKeyWindow)?
            .rootViewController
    }
}
