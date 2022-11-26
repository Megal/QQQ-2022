//
//  API.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-25.
//

import Foundation

struct API {
	enum ApiError: Error {
		case unsuccessful
	}

	struct Request {
		static var session = URLSession.shared
		static private var iso8601DateFormatter: DateFormatter = {
			let dt = DateFormatter()
			dt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

			return dt
		}()

		static private func makeRequestUrl(to endpoint: String) -> URL? {
			let config = SessionConfiguration.default
			let requestUrl = URL(string: "http://\(config.ip):\(config.port)/\(endpoint)")

			return requestUrl
		}

		static func current() async throws -> API.Response.Current {
			let requestUrl = makeRequestUrl(to: "current")!

			let (data, _) = try await session.data(from: requestUrl)

			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .formatted(iso8601DateFormatter)

//			let testData = API.Response.Current.testData
//			let testCurrent = try decoder.decode(API.Response.Current.self, from: testData.data(using: .utf8)!)
//			print("\(testCurrent)")

			let current = try decoder.decode(API.Response.Current.self, from: data)

			return current
		}

		static func participate() async throws {
			let requestUrl = makeRequestUrl(to: "participate")!

			let (_, response) = try await session.data(from: requestUrl)
			print("\(response)")

			guard let httpResponse = response as? HTTPURLResponse, 200..<400 ~= httpResponse.statusCode else {
				throw ApiError.unsuccessful
			}
		}

		static func getQuestions() async throws -> [API.Response.Question] {
			let requestUrl = makeRequestUrl(to: "getQuestions")!

			let (data, _) = try await session.data(from: requestUrl)
			let decoder = JSONDecoder()

			let questions = try decoder.decode([API.Response.Question].self, from: data)
			return questions
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

		/// [{"question":"Корень кубический из 49","answers":["7","5","14"],"correctAnswer":1},{"question":"Стоимость 98 сегодня","answers":["42","54","71"],"correctAnswer":2}]
		struct Question: Codable {
			var question: String?
			var answers: [String]?
			var correctAnswer: Int?
		}
	}

}
