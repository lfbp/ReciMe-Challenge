//
//  AnalyticsProvider.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

protocol AnalyticsProvider {
    func track(event: AnalyticsEvent)
    func setUserProperty(key: String, value: String)
    func setUserId(_ userId: String)
    func resetUser()
}
