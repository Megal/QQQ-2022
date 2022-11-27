//
//  QrCodeView.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-27.
//

import SwiftUI
import CoreImage.CIFilterBuiltins


struct QrCodeView: View {
	@State private var image: UIImage?
	@State private var screenBrightness: CGFloat?
	private var qrCode = "0123456789"

	var body: some View {
		GroupBox {
			if let image = image {
				Image(uiImage: image)
					.resizable()
					.interpolation(.none)
					.frame(width: 320, height: 320)
			}
		}
		.navigationTitle("Отсканируйте")
		.onAppear {
			screenBrightness = UIScreen.main.brightness
			UIScreen.main.brightness = 1.0
			generateImage()
		}
		.onDisappear {
			if let screenBrightness = screenBrightness {
				UIScreen.main.brightness = screenBrightness
			}
		}
	}

	private func generateImage() {
		guard image == nil else { return }

		let context = CIContext()
		let filter = CIFilter.qrCodeGenerator()
		filter.message = Data(qrCode.utf8)

		guard
			let outputImage = filter.outputImage,
			let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
		else { return }

		self.image = UIImage(cgImage: cgImage)
	}
}

@available(iOS 16.0, *)
struct QrCodeView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			QrCodeView()
		}
	}
}
