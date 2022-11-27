//
//  ApiResponse.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-27.
//

import Foundation

extension API {

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

		struct StartQuestion: Codable {
			static var mock = """
			{ status: "ok" }
			"""

			var status: String?
		}
	}


}
