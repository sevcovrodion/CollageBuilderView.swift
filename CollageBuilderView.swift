import SwiftUI

struct CollageBuilderView: View {
    
    @ObservedObject private(set) var store: AppStore
    
    private var collage: Collage { store.state.collage }
    private var collageSize: CGSize { store.state.collageSize }
    
    var body: some View {
        ZStack {
            collageView
                .overlay {
                    ControlPointsView(
                        selectedPointsIDs: store.state.selectedPointsIDs,
                        controlPoints: collage.controlPoints,
                        size: collageSize
                    )
                }
                .offset(
                    x: store.state.collageSettings.translation.x * collageSize.width,
                    y: store.state.collageSettings.translation.y * collageSize.height
                )
                .scaleEffect(store.state.collageSettings.scale)
                .layoutPriority(-1)
            
            VStack {
                TopBarView()
                DependentPointsConectorView()
                Spacer()
                gridEditor
                editor
            }
        }
        .environmentObject(store)
        .ignoresSafeArea(.keyboard)
    }
    
    private var gridEditor: some View {
        HStack {
            Button {
                store.dispatch(.switchEditMode)
            } label: {
                Text(store.state.editMode.rawValue)
            }
            Spacer()
            Button {
                store.dispatch(.togglePlayCollage)
            } label: {
                Image(systemName: store.state.isPlayingCollage
                      ? "pause.circle"
                      : "play.circle")
            }
            .font(.title2)
            Spacer()
            Button {
                store.dispatch(.toggleGrid)
            } label: {
                Image(systemName: "squareshape.split.3x3")
            }
            .font(.largeTitle)
            .foregroundColor(store.state.isShowingGrid ? .red : .blue)
        }
        .padding(.horizontal, 12)
        .frame(height: 50)
    }
    
    private var editor: some View {
        VStack {
            Text(editorDescription)
            .font(.title2)
            .padding()
            List {
                switch store.state.selectedElement {
                case .shape:
                    ShapeEditorView()
                case .text:
                    TextSelectorView()
                case .sticker:
                    StickerEditorView()
                case .none:
                    AddShapeElementView(size: collageSize)
                    CollageEditorView()
                }
            }
            .buttonStyle(.borderless)
        }
        .frame(height: 300)
        .background(Color(uiColor: .systemBackground))
    }
    
