//
//  NotificationName+Extension.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

import Foundation

extension Notification.Name{
    static var noInternetNotification = Notification.Name("noInternetNotification")
    static var slowInternetNotification = Notification.Name("slowInternetNotification")
    static var sessionIssue = Notification.Name("sessionIssue")
    static var backOnline = Notification.Name("backOnline")
    static var userAskToReload = Notification.Name("reloadData")
}
