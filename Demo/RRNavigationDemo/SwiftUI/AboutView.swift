import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("ℹ️ About")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("RRNavigation Demo App")
                .font(.title2)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 12) {
                AboutInfoRow(icon: "info.circle", title: "Version", value: "1.0.0")
                AboutInfoRow(icon: "swift", title: "Framework", value: "RRNavigation")
                AboutInfoRow(icon: "iphone", title: "Platform", value: "iOS 15+")
                AboutInfoRow(icon: "person.fill", title: "Developer", value: "Ronald Ruiz")
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("About")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct AboutInfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    AboutView()
}

