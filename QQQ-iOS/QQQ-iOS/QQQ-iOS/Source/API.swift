//
//  API.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-25.
//

import Foundation

struct API {
	struct Request {
		static var session = URLSession.shared
		static var iso8601DateFormatter: DateFormatter = {
			let dt = DateFormatter()
			dt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

			return dt
		}()

		static func current() async throws -> API.Response.Current {
			let config = SessionConfiguration.default
			let requestUrl = URL(string: "http://\(config.ip):\(config.port)/current")!
			let (data, _) = try await session.data(from: requestUrl)

			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .formatted(iso8601DateFormatter)

//			let testData = API.Response.Current.testData
//			let testCurrent = try decoder.decode(API.Response.Current.self, from: testData.data(using: .utf8)!)
//			print("\(testCurrent)")

			let current = try decoder.decode(API.Response.Current.self, from: data)

			return current
		}
	}

	struct Response {
		/// {"lessonName":"Compuhter science","professorName":"Иванов И. О.","from":"2022-12-29T05:00:00.000Z","to":"2022-12-29T06:50:00.000Z","url":"https://yandex.ru"}
		struct Current: Codable {
			static var testData = """
			{"lessonName":"Compuhter science","from":"2022-12-29T05:00:00.000Z","to":"2022-12-29T06:50:00.000Z","url":"https://yandex.ru"}
			"""
			var lessonName: String?
			var from: Date?
			var to: Date?
			var url: String?
			var professorName: String?
		}
	}

}
