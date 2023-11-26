//
//  NotificationManager.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 26.11.2023.
//

import Foundation


extension Notification.Name {
    static let changeLikeDislike = Notification.Name("changedLiked")
}


protocol NotificationsSender {
    func postNotification(for name: Notification.Name)
}



class NotificationManager: NotificationsSender {
    func postNotification(for name: Notification.Name) {
        NotificationCenter.default.post(
            name: name,
            object: nil
        )
    }
}
