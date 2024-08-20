import SwiftUI
import UIKit
import ImageIO

struct GIFImageView: UIViewRepresentable {
    let gifName: String
    let speed: Double
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        print(gifName)
        if let url = Bundle.main.url(forResource: gifName, withExtension: "gif") {
            let cfUrl = url as CFURL
            print(cfUrl)
            if let source = CGImageSourceCreateWithURL(cfUrl, nil) {
                var images: [UIImage] = []
                let count = CGImageSourceGetCount(source)
                print(count)
                for i in 0..<count {
                    if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                        images.append(UIImage(cgImage: cgImage))
                    }
                }
                if !images.isEmpty {
                    context.coordinator.images = images
                    context.coordinator.imageView = imageView
                    context.coordinator.currentFrameIndex = 0
                    Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
                        context.coordinator.updateFrame()
                    }
                }
            }
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        // No need to update UIView directly
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var images: [UIImage] = []
        var imageView: UIImageView?
        var currentFrameIndex = 0
        
        func updateFrame() {
            guard !images.isEmpty else { return }
            currentFrameIndex = (currentFrameIndex + 1) % images.count
            imageView?.image = images[currentFrameIndex]
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Animated GIF")
                .font(.headline)
                .padding()
            
            GIFImageView(gifName: "brown_walk_fast_8fps", speed: 0.2) // Adjust the speed here
                .frame(width: 300, height: 300)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(10)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
