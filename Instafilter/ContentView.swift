//
//  ContentView.swift
//  Instafilter
//
//  Created by Bruce Gilmour on 2021-07-26.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var processedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingFilterSheet = false
    @State private var showingImageAlert = false
    @State private var currentFilter: CIFilter = Self.filters[4].filter
    @State private var filterName = Self.filters[4].name
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 40.0
    @State private var filterScale = 30.0
    @State private var inputImage: UIImage?
    let context = CIContext()

    static let filters: [(filter: CIFilter, name: String)] = [
        (CIFilter.crystallize(), "Crystallize"),
        (CIFilter.edges(), "Edges"),
        (CIFilter.gaussianBlur(), "Gaussian Blur"),
        (CIFilter.pixellate(), "Pixellate"),
        (CIFilter.sepiaTone(), "Sepia Tone"),
        (CIFilter.unsharpMask(), "Unsharp Mask"),
        (CIFilter.vignette(), "Vignette"),
    ]

    var body: some View {
        let intensity = Binding<Double>(
            get: {
                filterIntensity
            },
            set: {
                filterIntensity = $0
                applyProcessing()
            }
        )

        let radius = Binding<Double>(
            get: {
                filterRadius
            },
            set: {
                filterRadius = $0
                applyProcessing()
            }
        )

        let scale = Binding<Double>(
            get: {
                filterScale
            },
            set: {
                filterScale = $0
                applyProcessing()
            }
        )

        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)

                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom)
                .onTapGesture {
                    showingImagePicker = true
                }

                if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                    HStack {
                        Text("Intensity (\(filterIntensity, specifier: "%.2f"))")
                        Slider(value: intensity)
                    }
                    .padding(.bottom)
                }

                if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                    HStack {
                        Text("Radius (\(filterRadius, specifier: "%.0f"))")
                        Slider(value: radius, in: 0 ... 80)
                    }
                    .padding(.bottom)
                }

                if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                    HStack {
                        Text("Scale (\(filterScale, specifier: "%.0f"))")
                        Slider(value: scale, in: 0 ... 60)
                    }
                    .padding(.bottom)
                }

                HStack {
                    Button(filterName) {
                        showingFilterSheet = true
                    }

                    Spacer()

                    Button("Save") {
                        saveImage()
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
            .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Select a filter"), buttons: [
                    filterButton(0),
                    filterButton(1),
                    filterButton(2),
                    filterButton(3),
                    filterButton(4),
                    filterButton(5),
                    filterButton(6),
                    .cancel()
                ])
            }
            .alert(isPresented: $showingImageAlert) {
                Alert(
                    title: Text("Save Error"),
                    message: Text("No image selected"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    func filterButton(_ index: Int) -> ActionSheet.Button {
        .default(Text(Self.filters[index].name)) {
            withAnimation {
                setFilter(Self.filters[index].filter)
                filterName = Self.filters[index].name
            }
        }
    }

    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }

        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale, forKey: kCIInputScaleKey) }

        guard let outputImage = currentFilter.outputImage else { return }

        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }

    func saveImage() {
        guard let processedImage = processedImage else {
            showingImageAlert = true
            return
        }

        let imageSaver = ImageSaver()

        imageSaver.successHandler = {
            print("Success!")
        }
        imageSaver.errorHandler = {
            print("Oops: \($0.localizedDescription)")
        }

        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
