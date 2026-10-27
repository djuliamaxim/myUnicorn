//
//  WelcomeScreenView.swift
//  myUnicorn
//
//  Created by Julia Maxim R. Davin on 5/26/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            MainTabView()
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
        } else {
            VStack(alignment: .leading, spacing: 24) {
                Spacer(minLength: 18)
                VStack (alignment: .center, spacing: 20){
                    hero
                }.frame(maxWidth: .infinity, alignment: .center)
                unicornCard
                quickHighlights
                Spacer()
                startButton
            }
            .padding(24)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
    
    private var hero: some View {
        VStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.purple.gradient)
                    .frame(width: 78, height: 78)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
            }
            .shadow(color: Color.purple.opacity(0.28), radius: 12, x: 0, y: 6)
            
            VStack(alignment: .center, spacing: 6) {
                Text("myUnicorn AI")
                    .font(.largeTitle.weight(.bold))
                Text("Visualize unicorn data and predict startup valuation tiers: High or Low.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var unicornCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            cardHeader(icon: "building.2.fill", title: "Unicorn")
            
            Text("A privately owned startup company estimated to be worth $1 billion or more.")
                .font(.headline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Usually a young, fast-growing tech or app company that has not gone public yet, but investors already believe it is worth at least a billion dollars.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    private var quickHighlights: some View {
        HStack(spacing: 12) {
            highlightTile(icon: "chart.line.uptrend.xyaxis", title: "Charts")
            highlightTile(icon: "map.fill", title: "Maps")
            highlightTile(icon: "brain.head.profile.fill", title: "AI Model")
        }
    }
    
    private var startButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.82)) {
                isActive = true
            }
        }) {
            HStack(spacing: 10) {
                Text("Get Started")
                    .fontWeight(.bold)
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title3)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .foregroundStyle(.white)
            .background(Color.purple.gradient, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: Color.purple.opacity(0.24), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
    
    private func cardHeader(icon: String, title: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.purple)
                .frame(width: 28, height: 28)
                .background(Color.purple.opacity(0.14), in: Circle())
            
            Text(title)
                .font(.headline)
        }
    }
    
    private func highlightTile(icon: String, title: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.headline.weight(.bold))
                .foregroundStyle(.purple)
                .frame(width: 34, height: 34)
                .background(Color.purple.opacity(0.14), in: Circle())
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    ContentView()
}
