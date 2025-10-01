import SwiftUI

struct Splash: View {
    @State private var glow = false

    private let starPoints: [(x: CGFloat, y: CGFloat, size: CGFloat)] = [
        (0.08, 0.12, 34), (0.90, 0.12, 30), (0.17, 0.33, 24),
        (0.78, 0.32, 18), (0.12, 0.52, 20), (0.50, 0.62, 28),
        (0.88, 0.70, 26), (0.10, 0.85, 18), (0.34, 0.80, 16),
        (0.62, 0.20, 14), (0.28, 0.18, 12), (0.72, 0.52, 12),
        (0.55, 0.85, 14)
    ]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("brandNavy")
                    .ignoresSafeArea()

                ForEach(0..<starPoints.count, id: \.self) { i in
                    let pt = starPoints[i]
                    Image("Star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: pt.size, height: pt.size)
                        .position(x: geo.size.width * pt.x,
                                  y: geo.size.height * pt.y)
                        .shadow(color: Color.white.opacity(glow ? 0.8 : 0.3),
                                radius: glow ? 6 : 2)
                }

                Text("Pawup")
                    .font(.custom("GNF", size: 50))
                    .kerning(2)
                    .foregroundColor(Color("BrandSC"))
                    .shadow(radius: 3)
            }
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    glow.toggle()
                }
            }
        }
    }
}


#Preview {
    Splash()
}
