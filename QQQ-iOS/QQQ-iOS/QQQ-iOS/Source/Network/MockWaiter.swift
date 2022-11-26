//
//  MockWaiter.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-26.
//

import Foundation

struct MockWaiter {
	static let defaultDelaySeconds = 1.5
	static func task(with string: String) async -> Data {
		let data = string.data(using: .utf8)!

		return await task(with: data)
	}

	static func task(with data: Data) async -> Data {
		if #available(iOS 16.0, *) {
			try! await Task.sleep(for: .seconds(defaultDelaySeconds))
		}

		return data
	}

}
