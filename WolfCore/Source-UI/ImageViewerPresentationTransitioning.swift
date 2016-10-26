//
//  ImageViewerPresentationTransitioning.swift
//  WolfCore
//
//  Created by Robert McNally on 7/25/16.
//  Copyright © 2016 Arciem LLC. All rights reserved.
//

import UIKit

class ImageViewerPresentationTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return defaultAnimationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! UINavigationController
        let viewerViewController = toViewController.viewControllers[0] as! ImageViewerViewController
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!

        let sourcePriorAlpha = viewerViewController.sourceImageView.alpha
        viewerViewController.sourceImageView.alpha = 0.0

        toView.alpha = 0.0
        viewerViewController.imageViewHidden = true

        let movingImageViewStartFrame = viewerViewController.sourceImageView.superview!.convert(viewerViewController.sourceImageView.frame, to: containerView)

        let movingImageViewEndFrame = viewerViewController.view.convert(viewerViewController.imageViewFrame, to: containerView)

        let movingImageView = UIImageView()
        movingImageView.contentMode = .scaleAspectFit
        movingImageView.image = viewerViewController.image
        movingImageView.frame = movingImageViewStartFrame

        containerView.addSubview(toView)
        containerView.addSubview(movingImageView)


        dispatchAnimated(
            duration: transitionDuration(using: transitionContext),
            animations: {
                toView.alpha = 1.0
                movingImageView.frame = movingImageViewEndFrame
            },
            completion: { finished in
                movingImageView.removeFromSuperview()
                viewerViewController.imageViewHidden = false
                viewerViewController.sourceImageView.alpha = sourcePriorAlpha
                let cancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!cancelled)
            }
        )
    }
}
