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
	var question: String? = "Вопрос 1.\n\nКакой ответ?"
	var options = ["Ответ 1", "Ответ 2", "Ответ 3"]
	var response = ""
	var started = false

	mutating func load() async {
		self.state = .loading
		self.response = ""

		do {
			let currentQuestion = try await API.Request.getCurrentQuestion()

			self.question = currentQuestion?.question
			self.options = currentQuestion?.answers ?? []

			self.state = .loaded
		} catch {
			self.response = error.localizedDescription

			self.state = .failedToLoad
		}
	}

	mutating func setAnswer(_ answerIndex: Int) async {
		let startedResponse = try? await API.Request.startQuestion(answerIndex)

		self.started = true
//		self.started = (startedResponse?.status == "ok")
	}

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
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	var body: some View {
		VStack {
			GroupBox {
				Text(vm.question ?? "")
				.frame(minWidth: 200.0)
			}
			ForEach(0..<vm.options.count) { optionIndex in
				GroupBox {
					Button(vm.options[optionIndex]) {
						Task {
							await vm.setAnswer(optionIndex)
						}
					}
					.frame(minWidth: 200.0)
				}
			}
		}
		.onChange(of: vm.started) { started in
			if started {
				if presentationMode.wrappedValue.isPresented {
					presentationMode.wrappedValue.dismiss()
				}
			}
		}
		.navigationTitle("Список вопросов")
	}
}

@available(iOS 16.0, *)
struct QuestionListView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			QuestionListView()
				.navigationTitle("QList")
		}
	}
}
