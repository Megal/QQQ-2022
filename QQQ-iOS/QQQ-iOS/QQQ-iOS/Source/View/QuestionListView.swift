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
	var question: String? = """
	Англичанин живёт в красном доме. У испанца есть собака. В зелёном доме пьют кофе. Украинец пьёт чай. Зелёный дом стоит сразу справа от белого дома. Тот, кто курит Old Gold, разводит улиток. В жёлтом доме курят Kool. В центральном доме пьют молоко. Норвежец живёт в первом доме. Сосед того, кто курит Chesterfield, держит лису. В доме по соседству с тем, в котором держат лошадь, курят Kool. Тот, кто курит Lucky Strike, пьёт апельсиновый сок. Японец курит Parliament. Норвежец живёт рядом с синим домом. Кто пьёт воду? Кто держит зебру?
	"""
	var options = [
		"Англичанин пьет воду, испанец держит зебру",
		"Норвежец пьет воду, японец держит зебру",
		"Японец пьет воду, испанец держит зебру"
	]
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
				.frame(minWidth: 200.0, maxWidth: 360.0)
			}
			ForEach(0..<vm.options.count) { optionIndex in
				GroupBox {
					Button(vm.options[optionIndex]) {
						back()
					}
				}
				.frame(minWidth: 300.0, maxWidth: 360.0)
				.onTapGesture {
					Task {
						await vm.setAnswer(optionIndex)
						if presentationMode.wrappedValue.isPresented {
							presentationMode.wrappedValue.dismiss()
						}
					}
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
		.navigationTitle("Ответить на вопрос")
	}

	private func back() {
		

	}
}

extension QuestionListView {
	enum Navigation {
		case back
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
