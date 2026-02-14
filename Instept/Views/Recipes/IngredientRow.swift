import SwiftUI

struct IngredientRow: View {
    let ingredient: Ingredient
    @State private var isChecked = false
    
    var body: some View {
        HStack {
            // Icon placeholder based on name (simple mapping or generic)
            ZStack {
                Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 40, height: 40)
                Text(ingredient.name.prefix(1))
                    .foregroundColor(.orange)
                    .fontWeight(.bold)
            }
            
            VStack(alignment: .leading) {
                Text(ingredient.name.capitalized)
                    .font(.body)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                Text("\(ingredient.amount) \(ingredient.unit)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                isChecked.toggle()
            }) {
                Circle()
                    .fill(isChecked ? Color.orange : Color.white)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 1)
                    )
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}
