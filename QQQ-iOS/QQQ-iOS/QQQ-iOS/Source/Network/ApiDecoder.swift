//
//  ApiDecoder.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-27.
//

import Foundation

extension API {
	struct Decoder {
		static private var iso8601DateFormatter: DateFormatter = {
			let dt = DateFormatter()
			dt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

			return dt
		}()

		static func jsonDecoder<T: Decodable>(postConfiguration: (JSONDecoder) -> Void = { _ in } ) -> ((Data) throws -> T) {
			let decoder = JSONDecoder()
			postConfiguration(decoder)

			return { (data: Data) throws -> T in
				return try decoder.decode(T.self, from: data)
			}
		}

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

		static func startQuestion(from data: Data) throws -> API.Response.StartQuestion {
			let decoder = JSONDecoder()

			let question = try decoder.decode(API.Response.StartQuestion.self, from: data)
			return question
		}

	}

}
