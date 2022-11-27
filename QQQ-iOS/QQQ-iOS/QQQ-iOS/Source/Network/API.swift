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

		static func startQuestion(_ number: Int) async throws -> Response.StartQuestion {
			let requestUrl = makeRequestUrl(to: "startQuestion")!

			let data: Data
			if !mockEverything {
				data = await MockWaiter.task(with: "")
			} else {
				(data, _) = try await session.data(from: requestUrl)
			}
			return try Decoder.jsonDecoder()(data)
		}

	}

	
}
