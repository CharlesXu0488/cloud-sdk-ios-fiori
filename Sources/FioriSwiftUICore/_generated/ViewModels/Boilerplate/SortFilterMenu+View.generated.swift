// Generated using Sourcery 1.2.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
//TODO: Copy commented code to new file: `FioriSwiftUICore/Views/SortFilterMenu+View.swift`
//TODO: Implement default Fiori style definitions as `ViewModifier`
//TODO: Implement SortFilterMenu `View` body
//TODO: Implement LibraryContentProvider

/// - Important: to make `@Environment` properties (e.g. `horizontalSizeClass`), internally accessible
/// to extensions, add as sourcery annotation in `FioriSwiftUICore/Models/ModelDefinitions.swift`
/// to declare a wrapped property
/// e.g.:  `// sourcery: add_env_props = ["horizontalSizeClass"]`

/*
import SwiftUI

// FIXME: - Implement Fiori style definitions

extension Fiori {
    enum SortFilterMenu {
        typealias Items = EmptyModifier
        typealias ItemsCumulative = EmptyModifier

        // TODO: - substitute type-specific ViewModifier for EmptyModifier
        /*
            // replace `typealias Subtitle = EmptyModifier` with:

            struct Subtitle: ViewModifier {
                func body(content: Content) -> some View {
                    content
                        .font(.body)
                        .foregroundColor(.preferredColor(.primary3))
                }
            }
        */
        static let items = Items()
        static let itemsCumulative = ItemsCumulative()
    }
}

// FIXME: - Implement SortFilterMenu View body

extension SortFilterMenu: View {
    public var body: some View {
        <# View body #>
    }
}

// FIXME: - Implement SortFilterMenu specific LibraryContentProvider

@available(iOS 14.0, macOS 11.0, *)
struct SortFilterMenuLibraryContent: LibraryContentProvider {
    @LibraryContentBuilder
    var views: [LibraryItem] {
        LibraryItem(SortFilterMenu(model: LibraryPreviewData.Person.laurelosborn),
                    category: .control)
    }
}
*/
