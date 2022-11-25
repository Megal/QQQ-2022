//
//  SessionConfiguration.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-25.
//

import Foundation

struct SessionConfiguration {
	var ip: String
	var port: Int
}

extension SessionConfiguration {
	static var `default` = SessionConfiguration(ip: "10.131.57.46", port: 3000)
}
