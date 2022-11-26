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
		static var mockEverything = true

		static private func makeRequestUrl(to endpoint: String) -> URL? {
			let config = SessionConfiguration.default
			let requestUrl = URL(string: "http://\(config.ip):\(config.port)/\(endpoint)")

			return requestUrl
		}

		static func current() async throws -> API.Response.Current {
			let requestUrl = makeRequestUrl(to: "current")!

			let data: Data
			if mockEverything {
				data = await MockWaiter.task(with: Response.Current.testData)
			} else {
				(data, _) = try await session.data(from: requestUrl)
			}

			return try Decoder.current(from: data)
		}

		static func participate() async throws {
			guard !mockEverything else {
				if #available(iOS 16.0, *) {
					try await Task.sleep(for: .seconds(MockWaiter.defaultDelaySeconds))
				}

				return
			}

			let requestUrl = makeRequestUrl(to: "participate")!

			let (_, response) = try await session.data(from: requestUrl)
			print("\(response)")

			guard let httpResponse = response as? HTTPURLResponse, 200..<400 ~= httpResponse.statusCode else {
				throw ApiError.unsuccessful
			}
		}

		static func getQuestions() async throws -> [API.Response.Question] {
			let requestUrl = makeRequestUrl(to: "getQuestions")!

			let data: Data
			if !mockEverything {
				data = await MockWaiter.task(with: Response.Question.mock)
			} else {
				(data, _) = try await session.data(from: requestUrl)
			}
			return try Decoder.getQuestions(from: data)
		}

		static func getCurrentQuestion() async throws -> API.Response.Question? {
			let requestUrl = makeRequestUrl(to: "getQuestions")!

			let data: Data
			if !mockEverything {
				data = await MockWaiter.task(with: Response.Question.currentMock)
			} else {
				(data, _) = try await session.data(from: requestUrl)
			}
			return try Decoder.getCurrentQuestion(from: data)
		}

		static func getQrCode() async throws -> Response.QrCode {
			let requestUrl = makeRequestUrl(to: "getQrCode")!

			let data: Data
			if !mockEverything {
				data = await MockWaiter.task(with: Response.Question.mock)
			} else {
				(data, _) = try await session.data(from: requestUrl)
			}
			return try Decoder.getQrCode(from: data)
		}
	}

	struct Decoder {
		static private var iso8601DateFormatter: DateFormatter = {
			let dt = DateFormatter()
			dt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

			return dt
		}()

		static func current(from data: Data) throws -> Response.Current {
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .formatted(iso8601DateFormatter)
			let current = try decoder.decode(API.Response.Current.self, from: data)
			return current
		}

		static func getQuestions(from data: Data) throws -> [Response.Question] {
			let decoder = JSONDecoder()

			let questions = try decoder.decode([API.Response.Question].self, from: data)
			return questions
		}

		static func getQrCode(from data: Data) throws -> API.Response.QrCode {
			let decoder = JSONDecoder()

			let questions = try decoder.decode(API.Response.QrCode.self, from: data)
			return questions
		}

		static func getCurrentQuestion(from data: Data) throws -> API.Response.Question {
			let decoder = JSONDecoder()

			let question = try decoder.decode(API.Response.Question.self, from: data)
			return question
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
			static var mock = """
			[{"question":"Корень кубический из 49","answers":["7","5","14"],"correctAnswer":1},{"question":"Стоимость 98 сегодня","answers":["42","54","71"],"correctAnswer":2}]
			"""
			static var currentMock = """
			{"question":"Корень кубический из 49","answers":["7","5","14"]}
			"""

			var question: String?
			var answers: [String]?
			var correctAnswer: Int?
		}

		struct QrCode: Codable {
			static var mock = """
			{qrCode: "ABIRVALG"}
			"""

			var qrCode: String
		}
	}

}
