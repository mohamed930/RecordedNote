//
//  PDFOptionsSheet.swift
//  RecordNote
//
//  Created by Mohamed Ali on 20/06/2026.
//

import SwiftUI

enum PDFContentOption: Int, CaseIterable {
    case summary
    case tasks
    case transcript

    var title: String {
        switch self {
        case .summary: return "Summary"
        case .tasks: return "Tasks"
        case .transcript: return "Transcript"
        }
    }
}

struct PDFOptionsSheet: View {

    @State private var selectedOptions: Set<PDFContentOption> = []
    @State private var isLoading: Bool = false

    var optionsSelected: ((Set<PDFContentOption>) -> Void)?
    var buttonTapped: ((@escaping () -> Void) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            VStack(alignment: .leading, spacing: 12) {
                Text("Export PDF")
                    .setFont(fontName: .mainFontBold, size: 22)
                    .foregroundStyle(Color._374151)

                Text("Include Content")
                    .setFont(fontName: .mainFontSemiBold, size: 11)
                    .foregroundStyle(Color._8_E_8_E_93)
            }
            .padding(.bottom, 18)

            VStack(spacing: 14) {
                ForEach(PDFContentOption.allCases, id: \.self) { option in
                    optionComponent(
                        title: option.title,
                        isSelected: selectedOptions.contains(option)
                    ) {
                        toggle(option)
                    }
                }
            }
            .padding(.bottom,14)
            
            AppButton(title: "Generate PDF",
                      isLoading: $isLoading,
                      icon: nil,
                      imagePosition: .leading) {
                isLoading = true

                buttonTapped? {
                    isLoading = false
                }
            }
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }

    private func toggle(_ option: PDFContentOption) {
        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
        } else {
            selectedOptions.insert(option)
        }

        optionsSelected?(selectedOptions)
    }
    
    @ViewBuilder
    private func optionComponent(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .setFont(fontName: .mainFontMeduim, size: 15)
                    .foregroundStyle(Color._374151)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(
                            isSelected
                            ? Color._7_C_3_AED
                            : Color.white
                        )
                    
                    Circle()
                        .strokeBorder(
                            isSelected
                            ? Color._7_C_3_AED
                            : Color.D_1_D_5_DB,
                            lineWidth: 2
                        )
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 30, height: 30)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 62)
            .padding(.horizontal, 18)
            .background(Color.F_9_FAFB)
            .borderedCornerRadius(
                16,
                corners: .allCorners,
                lineWidth: 1,
                borderColor: .EBEBEF
            )
        }
    }
}

#Preview {
    PDFOptionsSheet()
}
