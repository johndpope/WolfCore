//
//  ImageViewerDismissalTransitioning.swift
//  WolfCore
//
//  Created by Robert McNally on 7/26/16.
//  Copyright © 2016 Arciem LLC. All rights reserved.
//


import UIKit

class ImageViewerDismissalTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return defaultAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey) as! UINavigationController
        let viewerViewController = fromViewController.viewControllers[0] as! ImageViewerViewController
        let fromView = transitionContext.view(forKey: UITransitionContextFromViewKey)!

        let sourcePriorAlpha = viewerViewController.sourceImageView.alpha
        viewerViewController.sourceImageView.alpha = 0.0

        fromView.alpha = 1.0
        viewerViewController.imageViewHidden = true

        let movingImageViewStartFrame = viewerViewController.view.convert(viewerViewController.imageViewFrame, to: containerView)

        let movingImageViewEndFrame = viewerViewController.sourceImageView.superview!.convert(viewerViewController.sourceImageView.frame, to: containerView)

        let movingImageView = UIImageView()
        movingImageView.contentMode = .scaleAspectFit
        movingImageView.image = viewerViewController.image
        movingImageView.frame = movingImageViewStartFrame

        containerView.addSubview(movingImageView)

        dispatchAnimated(
            duration: transitionDuration(using: transitionContext),
            animations: {
                fromView.alpha = 0.0
                movingImageView.frame = movingImageViewEndFrame
            },
            completion: { finished in
                viewerViewController.sourceImageView.alpha = sourcePriorAlpha
                movingImageView.removeFromSuperview()
                viewerViewController.imageViewHidden = false
                let cancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!cancelled)
            }
        )
    }
}
