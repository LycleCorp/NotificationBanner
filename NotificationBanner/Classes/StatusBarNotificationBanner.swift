/*

 The MIT License (MIT)
 Copyright (c) 2017-2018 Dalton Hinterscher

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 */

import UIKit

import MarqueeLabel

@objcMembers
open class StatusBarNotificationBanner: BaseNotificationBanner {

    public override var bannerHeight: CGFloat {
        get {
            if let customBannerHeight = customBannerHeight {
                return customBannerHeight
            } else if shouldAdjustForDynamicIsland() {
                return 70.0
            } else if shouldAdjustForNotchFeaturedIphone() {
                return 50.0
            } else {
                return 20.0 + heightAdjustment
            }
        } set {
            customBannerHeight = newValue
        }
    }

    override init(style: BannerStyle, colors: BannerColorsProtocol? = nil) {
        super.init(style: style, colors: colors)
        autoLayoutLabelComponents()
        updateMarqueeLabelsDurations()
    }
    
    private func autoLayoutLabelComponents() {
        
        let spacer = UIView()
        spacer.backgroundColor = backgroundColor
        spacer.snp.makeConstraints { make in
            make.height.equalTo(heightAdjustment)
        }
        
        titleLabel = MarqueeLabel()
        (titleLabel as! MarqueeLabel).animationDelay = 2
        (titleLabel as! MarqueeLabel).type = .leftRight
        titleLabel!.font = UIFont.systemFont(ofSize: 12.5, weight: UIFont.Weight.bold)
        titleLabel!.textAlignment = .center
        titleLabel!.textColor = .white
        titleLabel?.backgroundColor = backgroundColor
        
        let spacerAndLabelVStack: UIStackView = {
           let vStack = UIStackView(arrangedSubviews: [
            spacer,
            titleLabel!
           ])
            vStack.axis = .vertical
            vStack.alignment = .fill
            vStack.spacing = 0
            vStack.distribution = .fill
            return vStack
        }()
    
        contentView.addSubview(spacerAndLabelVStack)
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false

        spacerAndLabelVStack.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }

    public convenience init(
        title: String,
        style: BannerStyle = .info,
        colors: BannerColorsProtocol? = nil
    ) {
        self.init(style: style, colors: colors)
        titleLabel!.text = title
    }

    public convenience init(
        attributedTitle: NSAttributedString,
        style: BannerStyle = .info,
        colors: BannerColorsProtocol? = nil
    ) {
        self.init(style: style, colors: colors)
        titleLabel!.attributedText = attributedTitle
    }

    public init(customView: UIView) {
        super.init(style: .customView)
        self.customView = customView
        
        contentView.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        spacerView.backgroundColor = customView.backgroundColor
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

public extension StatusBarNotificationBanner {
    
    func applyStyling(
        titleColor: UIColor? = nil,
        titleTextAlign: NSTextAlignment? = nil
    ) {
        
        if let titleColor = titleColor {
            titleLabel!.textColor = titleColor
        }
        
        if let titleTextAlign = titleTextAlign {
            titleLabel!.textAlignment = titleTextAlign
        }
    }
    
}
