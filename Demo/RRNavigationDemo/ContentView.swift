import SwiftUI
import RRNavigation

struct ContentView: View {
    var body: some View {
        VStack {
            
            VStack {
                Text("RRNavigation Demo")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Text("This demo showcases the RRNavigation library with tab-based navigation and routing capabilities.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .navigation()
        }
    }
    
    
}

#Preview {
    ContentView()
}
