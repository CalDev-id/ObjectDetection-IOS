import SwiftUI
import AVFoundation
import Vision

struct LiveCameraView: View {
    @State private var showResultSheet: Bool = false
    @State private var detectedObjects: [Observation] = []
    let model = try! YOLOv3Tiny(configuration: MLModelConfiguration())

    var body: some View {
        VStack {
            Text("YOLOv3")
                .font(.title3)
            CameraView(capturedImage: $detectedObjects, showResultSheet: $showResultSheet)
                .edgesIgnoringSafeArea(.all)
                .sheet(isPresented: $showResultSheet) {
                    ResultView(detectedObjects: detectedObjects)
                }
        }
    }
}

struct CameraView: View {
    @State private var isSessionRunning = false
    @State private var session: AVCaptureSession?
    @State private var previewLayer: AVCaptureVideoPreviewLayer?
    @Binding var capturedImage: [Observation]
    @Binding var showResultSheet: Bool

    var body: some View {
        ZStack {
            if let previewLayer = previewLayer {
                PreviewLayerView(previewLayer: previewLayer)
                    .onAppear {
                        self.setupCamera()
                    }
            } else {
                Text("Camera unavailable")
            }
        }
    }

    private func setupCamera() {
        let session = AVCaptureSession()
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(input) else {
            return
        }

        session.addInput(input)
        session.startRunning()

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill

        DispatchQueue.main.async {
            self.session = session
            self.previewLayer = previewLayer
            self.isSessionRunning = session.isRunning
        }
    }
}

struct PreviewLayerView: UIViewRepresentable {
    var previewLayer: AVCaptureVideoPreviewLayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        previewLayer.frame = uiView.bounds
    }
}

struct ResultView: View {
    let detectedObjects: [Observation]

    var body: some View {
        VStack {
            // Your result view content here
        }
    }
}
