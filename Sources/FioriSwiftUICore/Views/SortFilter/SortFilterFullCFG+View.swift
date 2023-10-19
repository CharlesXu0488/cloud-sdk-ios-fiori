import SwiftUI

extension Fiori {
    enum SortFilterFullCFG {
//        typealias Title = EmptyModifier
        struct Title: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .font(.body)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(Color.preferredColor(.primaryLabel))
                    .multilineTextAlignment(.center)
            }
        }
        typealias TitleCumulative = EmptyModifier
        typealias Items = EmptyModifier
        typealias ItemsCumulative = EmptyModifier
        typealias CancelAction = EmptyModifier
        typealias CancelActionCumulative = EmptyModifier
        typealias ResetAction = EmptyModifier
        typealias ResetActionCumulative = EmptyModifier
        typealias ApplyAction = EmptyModifier
        typealias ApplyActionCumulative = EmptyModifier
        

        static let title = Title()
        static let items = Items()
        static let cancelAction = CancelAction()
        static let resetAction = ResetAction()
        static let applyAction = ApplyAction()
        static let titleCumulative = TitleCumulative()
        static let itemsCumulative = ItemsCumulative()
        static let cancelActionCumulative = CancelActionCumulative()
        static let resetActionCumulative = ResetActionCumulative()
        static let applyActionCumulative = ApplyActionCumulative()
    }
}

extension SortFilterFullCFG: View {
    public var body: some View {
        CancellableResettableDialogForm {
            title
        } cancelAction: {
            cancelAction
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            print("...Cancel...")
                            context.handleCancel?()
                            context.isApplyButtonEnabled = false
                            context.isResetButtonEnabled = false
                            dismiss()
                        }
                )
                .buttonStyle(CancelResetButtonStyle())
        } resetAction: {
            resetAction
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            print("...Reset...")
                            context.handleReset?()
                            context.isApplyButtonEnabled = false
                            context.isResetButtonEnabled = false
                            dismiss()
                        }
                )
                .buttonStyle(CancelResetButtonStyle())
        } applyAction: {
            applyAction
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            print("...Apply...")
                            context.handleApply?()
                            context.isApplyButtonEnabled = false
                            context.isResetButtonEnabled = false
                            _onUpdate?()
                            dismiss()
                        }
                )

                .buttonStyle(ApplyButtonStyle())
        } components: {
            _items
                .environmentObject(context)
        }
    }
}

/*
 // FIXME: - Implement SortFilterFullCFG specific LibraryContentProvider

 @available(iOS 14.0, macOS 11.0, *)
 struct SortFilterFullCFGLibraryContent: LibraryContentProvider {
     @LibraryContentBuilder
     var views: [LibraryItem] {
         LibraryItem(SortFilterFullCFG(model: LibraryPreviewData.Person.laurelosborn),
                     category: .control)
     }
 }
 */
