//
//  QuestionListView.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-26.
//

import SwiftUI

// WIP
struct QuestionListViewModel {
	enum State: String {
		case firstLoad
		case loading
		case failedToLoad
		case loaded

		var descriptuion: String {
			"\(self)"
		}
	}

	var state = State.loaded
	var lessonName = "Computer Science 101"
	var start = ISO8601DateFormatter().date(from: "2022-11-27T15:00:00+03:00")
	var end = ISO8601DateFormatter().date(from: "2022-11-27T16:30:00+03:00")
	var professorName = "Читающий Нам Лекторович"
	var groupName = "A-77"
	var onlineUrl: URL? = URL(string: "https://google.com")
	var response = ""

	mutating func load() async {
		self.state = .loading
		self.response = ""

		do {
			let current = try await API.Request.current()

			self.lessonName = current.lessonName ?? "Лекция"
			self.start = current.from
			self.end = current.to
			self.onlineUrl = URL(string: current.url ?? "")
			self.professorName = current.professorName ?? ""

			self.state = .loaded
		} catch {
			self.response = error.localizedDescription

			self.state = .failedToLoad
		}
	}

	mutating func askQuestion() async {}
}

struct QuestionListView: View {
	@State private var vm = QuestionListViewModel()

	@State private var prismViewBuilder = PrismViewBuilder()
//	private func makePrismView() -> some View {
//		prismViewBuilder.makePrismView {
//			Text("Задать вопрос")
//		}
//		.onTapGesture(perform: onAskButton)
//	}




	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
	}
}

@available(iOS 16.0, *)
struct QuestionListView_Previews: PreviewProvider {
	static var previews: some View {
		QuestionListView()
	}
}
