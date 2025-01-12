// Generated using Sourcery 2.1.3 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import Foundation
import SwiftUI

public struct Card {
    let mediaImage: any View
    let description: any View
    let title: any View
    let subtitle: any View
    let detailImage: any View
    let counter: any View
    let row1: any View
    let row2: any View
    let row3: any View
    let cardBody: any View
    let newAction: any View
    let secondaryAction: any View

    @Environment(\.cardStyle) var style

    fileprivate var _shouldApplyDefaultStyle = true

    public init(@ViewBuilder mediaImage: () -> any View = { EmptyView() },
                @ViewBuilder description: () -> any View = { EmptyView() },
                @ViewBuilder title: () -> any View,
                @ViewBuilder subtitle: () -> any View = { EmptyView() },
                @ViewBuilder detailImage: () -> any View = { EmptyView() },
                @ViewBuilder counter: () -> any View = { EmptyView() },
                @ViewBuilder row1: () -> any View = { EmptyView() },
                @ViewBuilder row2: () -> any View = { EmptyView() },
                @ViewBuilder row3: () -> any View = { EmptyView() },
                @ViewBuilder cardBody: () -> any View = { EmptyView() },
                @ViewBuilder newAction: () -> any View = { EmptyView() },
                @ViewBuilder secondaryAction: () -> any View = { EmptyView() })
    {
        self.mediaImage = MediaImage { mediaImage() }
        self.description = Description { description() }
        self.title = Title { title() }
        self.subtitle = Subtitle { subtitle() }
        self.detailImage = DetailImage { detailImage() }
        self.counter = Counter { counter() }
        self.row1 = Row1 { row1() }
        self.row2 = Row2 { row2() }
        self.row3 = Row3 { row3() }
        self.cardBody = CardBody { cardBody() }
        self.newAction = NewAction { newAction() }
        self.secondaryAction = SecondaryAction { secondaryAction() }
    }
}

public extension Card {
    init(mediaImage: Image? = nil,
         description: AttributedString? = nil,
         title: AttributedString,
         subtitle: AttributedString? = nil,
         detailImage: Image? = nil,
         counter: AttributedString? = nil,
         @ViewBuilder row1: () -> any View = { EmptyView() },
         @ViewBuilder row2: () -> any View = { EmptyView() },
         @ViewBuilder row3: () -> any View = { EmptyView() },
         @ViewBuilder cardBody: () -> any View = { EmptyView() },
         newAction: FioriButton? = nil,
         secondaryAction: FioriButton? = nil)
    {
        self.init(mediaImage: { mediaImage }, description: { OptionalText(description) }, title: { Text(title) }, subtitle: { OptionalText(subtitle) }, detailImage: { detailImage }, counter: { OptionalText(counter) }, row1: row1, row2: row2, row3: row3, cardBody: cardBody, newAction: { newAction }, secondaryAction: { secondaryAction })
    }
}

public extension Card {
    init(_ configuration: CardConfiguration) {
        self.mediaImage = configuration.mediaImage
        self.description = configuration.description
        self.title = configuration.title
        self.subtitle = configuration.subtitle
        self.detailImage = configuration.detailImage
        self.counter = configuration.counter
        self.row1 = configuration.row1
        self.row2 = configuration.row2
        self.row3 = configuration.row3
        self.cardBody = configuration.cardBody
        self.newAction = configuration.newAction
        self.secondaryAction = configuration.secondaryAction
        self._shouldApplyDefaultStyle = false
    }
}

extension Card: View {
    public var body: some View {
        if _shouldApplyDefaultStyle {
            self.defaultStyle()
        } else {
            style.resolve(configuration: .init(mediaImage: .init(self.mediaImage), description: .init(self.description), title: .init(self.title), subtitle: .init(self.subtitle), detailImage: .init(self.detailImage), counter: .init(self.counter), row1: .init(self.row1), row2: .init(self.row2), row3: .init(self.row3), cardBody: .init(self.cardBody), newAction: .init(self.newAction), secondaryAction: .init(self.secondaryAction))).typeErased
                .transformEnvironment(\.cardStyleStack) { stack in
                    if !stack.isEmpty {
                        stack.removeLast()
                    }
                }
        }
    }
}

private extension Card {
    func shouldApplyDefaultStyle(_ bool: Bool) -> some View {
        var s = self
        s._shouldApplyDefaultStyle = bool
        return s
    }
        
    func defaultStyle() -> some View {
        Card(.init(mediaImage: .init(self.mediaImage), description: .init(self.description), title: .init(self.title), subtitle: .init(self.subtitle), detailImage: .init(self.detailImage), counter: .init(self.counter), row1: .init(self.row1), row2: .init(self.row2), row3: .init(self.row3), cardBody: .init(self.cardBody), newAction: .init(self.newAction), secondaryAction: .init(self.secondaryAction)))
            .shouldApplyDefaultStyle(false)
            .cardStyle(CardFioriStyle.ContentFioriStyle())
    }
}
