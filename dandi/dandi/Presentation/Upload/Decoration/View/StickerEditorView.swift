//
//  StickerEditorView.swift
//  dandi
//
//  Created by 김윤서 on 2023/03/12.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then
import YDS

final class StickerEditorView: UIView {
    private var touchStart: CGPoint?
    private var previousPoint: CGPoint?
    private var deltaAngle: CGFloat?

    private var resizingControl: StickerEditorViewControl!
    private var deleteControl: StickerEditorViewControl!
    private var borderView: BorderView!

    private var oldBounds: CGRect!
    private var oldTransform: CGAffineTransform!

    init(image: UIImage) {
        let stickerImageView = UIImageView(image: image)
        super.init(frame: stickerImageView.frame)

        setupContentView(content: stickerImageView)
        setupDefaultAttributes()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupDefaultAttributes()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupDefaultAttributes()
    }

    func switchControls(toState state: Bool, animated: Bool = false) {
        if animated {
            let controlAlpha: CGFloat = state ? 1 : 0
            UIView.animate(withDuration: 0.3, animations: {
                self.resizingControl.alpha = controlAlpha
                self.deleteControl.alpha = controlAlpha
                self.borderView.alpha = controlAlpha
            })
        } else {
            resizingControl.isHidden = !state
            deleteControl.isHidden = !state
            borderView.isHidden = !state
        }
    }

    private func setupDefaultAttributes() {
        borderView = BorderView(frame: bounds)
        addSubview(borderView)

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        deleteControl = StickerEditorViewControl(image: UIImage(named: "btnClose"), gestureRecognizer: singleTap)
        addSubview(deleteControl)

        let panResizeGesture = UIPanGestureRecognizer(target: self, action: #selector(resizeTranslate))
        resizingControl = StickerEditorViewControl(image: UIImage(named: "btnRotation"),
                                                   gestureRecognizer: panResizeGesture)
        addSubview(resizingControl)

        let pinchResizeGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        pinchResizeGesture.delegate = self
        addGestureRecognizer(pinchResizeGesture)

        let rotateResizeGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
        rotateResizeGesture.delegate = self
        addGestureRecognizer(rotateResizeGesture)

        updateControlsPosition()

        deltaAngle = atan2(frame.origin.y + frame.height - center.y, frame.origin.x + frame.width - center.x)
    }

    private func setupContentView(content: UIView) {
        let contentView = UIView(frame: content.frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(content)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)

        for subview in contentView.subviews {
            subview.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
            subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }

    // MARK: Gestures with controls

    @objc private func singleTap(recognizer: UIPanGestureRecognizer) {
        let close = recognizer.view
        if let close = close {
            close.superview?.removeFromSuperview()
        }
    }

    @objc private func resizeTranslate(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            enableTranslucency(state: true)
            previousPoint = recognizer.location(in: self)
            setNeedsDisplay()

        } else if recognizer.state == .changed {
            resizeView(recognizer: recognizer)
            rotateView(with: deltaAngle, recognizer: recognizer)

        } else if recognizer.state == .ended {
            enableTranslucency(state: false)
            previousPoint = recognizer.location(in: self)
            setNeedsDisplay()
        }
        updateControlsPosition()
    }

    private func resizeView(recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: self)
        guard let previousPoint = previousPoint else {
            return
        }
        let diagonal = sqrt(pow(point.x, 2) + pow(point.y, 2))
        let previousDiagonal = sqrt(pow(previousPoint.x, 2) + pow(previousPoint.y, 2))
        let totalRatio = pow(diagonal / previousDiagonal, 2)

        bounds = CGRect(x: 0, y: 0, width: bounds.size.width * totalRatio, height: bounds.size.height * totalRatio)
        self.previousPoint = recognizer.location(in: self)
    }

    private func rotateView(with deltaAngle: CGFloat?, recognizer: UIPanGestureRecognizer) {
        let angle = atan2(recognizer.location(in: superview).y - center.y,
                          recognizer.location(in: superview).x - center.x)

        if let deltaAngle = deltaAngle {
            let angleDiff = deltaAngle - angle
            transform = CGAffineTransformMakeRotation(-angleDiff)
        }
    }

    private func updateControlsPosition() {
        let offset: CGFloat = 5
        borderView.frame = CGRect(
            x: -offset,
            y: -offset,
            width: bounds.size.width + offset * 2,
            height: bounds.size.height + offset * 2
        )

        deleteControl.center = CGPoint(
            x: borderView.frame.origin.x,
            y: borderView.frame.origin.y
        )
        resizingControl.center = CGPoint(
            x: borderView.frame.origin.x + borderView.frame.size.width,
            y: borderView.frame.origin.y + borderView.frame.size.height
        )
    }

    // MARK: Gestures without controls

    @objc private func pinch(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began {
            oldBounds = bounds
            enableTranslucency(state: true)
            previousPoint = recognizer.location(in: self)
            setNeedsDisplay()
        } else if recognizer.state == .changed {
            bounds = CGRect(x: 0, y: 0, width: oldBounds.width * recognizer.scale,
                            height: oldBounds.height * recognizer.scale)
        } else if recognizer.state == .ended {
            oldBounds = bounds
            enableTranslucency(state: false)
            previousPoint = recognizer.location(in: self)
            setNeedsDisplay()
        }
        updateControlsPosition()
    }

    @objc private func rotate(recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == .began {
            oldTransform = transform
            enableTranslucency(state: true)
            previousPoint = recognizer.location(in: self)
            setNeedsDisplay()
        } else if recognizer.state == .changed {
            transform = CGAffineTransformRotate(oldTransform, recognizer.rotation)
        } else if recognizer.state == .ended {
            oldTransform = transform
            enableTranslucency(state: false)
            previousPoint = recognizer.location(in: self)
            setNeedsDisplay()
        }
        updateControlsPosition()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        enableTranslucency(state: true)

        let touch = touches.first
        if let touch = touch {
            touchStart = touch.location(in: superview)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        let touchLocation = touches.first?.location(in: self)
        if resizingControl.frame.contains(touchLocation!) {
            return
        }

        let touch = touches.first?.location(in: superview)
        translateUsingTouchLocation(touchPoint: touch!)
        touchStart = touch
    }

    override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        enableTranslucency(state: false)
    }

    private func translateUsingTouchLocation(touchPoint: CGPoint) {
        if let touchStart = touchStart {
            center = CGPoint(x: center.x + touchPoint.x - touchStart.x, y: center.y + touchPoint.y - touchStart.y)
        }
    }

    private func enableTranslucency(state: Bool) {
        UIView.animate(withDuration: 0.1) {
            if state == true {
                self.alpha = 0.65
            } else {
                self.alpha = 1
            }
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if resizingControl.frame.contains(point) || deleteControl.frame.contains(point) || bounds.contains(point) {
            for subview in subviews.reversed() {
                let convertedPoint = subview.convert(point, from: self)
                let hitTestView = subview.hitTest(convertedPoint, with: event)
                if hitTestView != nil {
                    return hitTestView
                }
            }
            return self
        }
        return nil
    }
}

extension StickerEditorView: UIGestureRecognizerDelegate {
    private func gestureRecognizer(
        gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return gestureRecognizer.isKind(of: UIPinchGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIRotationGestureRecognizer.self)
    }
}

class StickerEditorViewControl: UIImageView {
    init(image: UIImage?, gestureRecognizer: UIGestureRecognizer) {
        super.init(image: image)

        addGestureRecognizer(gestureRecognizer)
        self.frame = CGRect(
            x: 0,
            y: 0,
            width: 36,
            height: 36
        )

        layer.cornerRadius = frame.width / 2
        backgroundColor = .cyan
        isUserInteractionEnabled = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BorderView: UIView {
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            context.saveGState()
            context.setLineWidth(1)

            let dash: [CGFloat] = [4.0, 2.0]
            context.setLineDash(phase: 0.0, lengths: dash)

            UIColor.white.setStroke()

            context.addRect(rect)
            context.strokePath()

            context.restoreGState()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
    }
}
