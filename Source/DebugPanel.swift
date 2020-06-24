//
//  DebugPanel.swift
//  DebugPanel
//
//  Created by xaoxuu on 2020/6/19.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit
import SnapKit

fileprivate func Stack() -> UIStackView {
    let stack = UIStackView()
    stack.distribution = .fill
    stack.alignment = .fill
    stack.axis = .vertical
    return stack
}

/// 调试面板
public class DebugPanel: UIWindow {
    
    /// 单例
    public static let shared = DebugPanel()
    
    /// 需要手动指定宽度
    public var width: CGFloat {
        set {
            frame.size.width = newValue
        }
        get {
            return frame.width
        }
    }
    
    public var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }
    
    // MARK: 布局
    
    /// 行高
    public var lineHeight = CGFloat(32)
    
    /// 标题
    public var titleLabel = UILabel()
    
    /// 间隔
    public var gap = CGFloat(8)
    
    /// 主堆栈
    public let mainStack = Stack()
    
    /// 按钮堆栈
    public let actionStack = Stack()
    
    /// 分割线
    public let separator = UIView()
    
    /// 按钮
    public var btns = [UIButton]()
    
    /// 事件
    public var actions = [(UIButton) -> Void]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        windowLevel = UIWindow.Level(UIWindow.Level.alert.rawValue + 1)
        
        let vc = UIViewController()
        rootViewController = vc
        
        backgroundColor = .white
        layer.cornerRadius = 12
        
        layer.shadowRadius = 8
        layer.shadowOffset = .init(width: 0, height: 5)
        layer.shadowOpacity = 0.2
        
        if #available(iOS 13, *) {
            windowScene = UIApplication.shared.windows.last?.windowScene
        }
        
        isHidden = false
        
        vc.view.addSubview(mainStack)
        mainStack.snp.makeConstraints { (mk) in
            mk.top.leading.equalToSuperview().offset(gap)
            mk.bottom.right.equalToSuperview().offset(-gap)
        }
        
        mainStack.spacing = gap
        mainStack.addArrangedSubview(titleLabel)
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        mainStack.addArrangedSubview(separator)
        separator.backgroundColor = .init(white: 0.9, alpha: 1)
        separator.snp.makeConstraints { (mk) in
            mk.height.equalTo(1)
        }
        
        
        mainStack.addArrangedSubview(actionStack)
        actionStack.distribution = .fillEqually
        
        // 拖动
        vc.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan(_:))))
        
    }
    
    convenience init() {
        self.init(frame: .init(x: 0, y: 0, width: 120, height: 100))
        if let x = UserDefaults.standard.value(forKey: "DebugPanel.frame.origin.x") as? CGFloat, let y = UserDefaults.standard.value(forKey: "DebugPanel.frame.origin.y") as? CGFloat {
            frame.origin = CGPoint(x: x, y: y)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - 快速布局
public extension DebugPanel {
    
    /// 加载面板
    /// - Parameter callback: 回调
    static func load(_ callback: (DebugPanel) -> Void) {
        callback(shared)
        shared.commit()
    }
    
    /// 更新面板按钮
    /// - Parameters:
    ///   - index: 按钮索引（从0开始）
    ///   - title: 按钮新的标题
    static func update(button index: Int, title: String) {
        if index < shared.btns.count {
            let btn = shared.btns[index]
            btn.setTitle(title, for: .normal)
        }
    }
    
    /// 增加按钮
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - action: 事件
    func add(_ title: String, action: ((UIButton) -> Void)? = nil) {
        let btn = UIButton(type: .system)
        actionStack.addArrangedSubview(btn)
        btn.setTitle(title, for: .normal)
        if let ac = action {
            btn.addTarget(self, action: #selector(self.didTouchDown(_:)), for: .touchDown)
            btn.addTarget(self, action: #selector(self.didTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
            btn.addTarget(self, action: #selector(self.didTapped(_:)), for: .touchUpInside)
            btn.tag = btns.count
            print(btn.tag)
            actions.append(ac)
            btns.append(btn)
        } else {
            btn.isEnabled = false
            btn.setTitleColor(.gray, for: .normal)
        }
        
        btn.layer.cornerRadius = 4
    }
    
    /// 提交更改，（如果在 loadPanel 和 updatePanel 块之外修改了布局，需要手动调用此函数）
    func commit() {
        frame.size.height = CGFloat(actionStack.arrangedSubviews.count) * lineHeight + 4 * gap + lineHeight * 1 + 1
        for v in mainStack.arrangedSubviews {
            v.snp.makeConstraints { (mk) in
                mk.height.equalTo(lineHeight)
            }
        }
        if frame.origin == .zero {
            frame.origin.y = screen.bounds.size.height - frame.size.height - gap
            frame.origin.x = screen.bounds.size.width - frame.size.width - gap
        }
    }
    
}


// MARK: - 事件
extension DebugPanel {
    @objc func didTouchDown(_ sender: UIButton) {
        sender.backgroundColor = .init(white: 0, alpha: 0.05)
    }
    @objc func didTouchUp(_ sender: UIButton) {
        sender.backgroundColor = .clear
    }
    @objc func didTapped(_ sender: UIButton) {
        let tag = sender.tag
        if (0 ..< actions.count).contains(tag) {
            actions[tag](sender)
        }
    }

    /// 拖拽事件
    /// - Parameter sender: 手势
    @objc func didPan(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: sender.view)
        transform = .init(translationX: point.x, y: point.y)
        if sender.state == .recognized {
            let superSize = UIScreen.main.bounds.size
            let size = frame.size
            transform = .identity
            frame.origin = CGPoint(x: frame.origin.x + point.x, y: frame.origin.y + point.y)
            let margin = CGFloat(8)
            if frame.origin.x < margin {
                frame.origin.x = margin
            }
            if frame.origin.y < margin {
                frame.origin.y = margin
            }
            if frame.maxX > superSize.width - margin {
                frame.origin.x = superSize.width - size.width - margin
            }
            if frame.maxY > superSize.height - margin {
                frame.origin.y = superSize.height - size.height - margin
            }
            UserDefaults.standard.set(frame.origin.x, forKey: "DebugPanel.frame.origin.x")
            UserDefaults.standard.set(frame.origin.y, forKey: "DebugPanel.frame.origin.y")
            UserDefaults.standard.synchronize()
        }
    }
}
