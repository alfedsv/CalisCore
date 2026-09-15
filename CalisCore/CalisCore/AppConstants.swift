//
//  AppConstants.swift
//  CalisCore
//
//  Created by  Alexander Fedoseev on 15.09.2026.
//

import Foundation

enum AppConstants {
    enum Layout {
        static let paddingLargeButtonBottom: CGFloat = 25
        static let paddingLargeButton: CGFloat = 45
        
        static let buttonCornerRadius: CGFloat = 10
        static let buttonHeightStandard: CGFloat = 45
        static let buttonHeightSmall: CGFloat = 30
        
        static let imageCornerRadius: CGFloat = 4
        static let recomendationViewCornerRadius: CGFloat = 10  // RecomendationView
        
        static let imageSmallSide: CGFloat = 100                // WarmUpCoolDownView
        static let imageLargeSide: CGFloat = 200                // ExerciseViewController
    }
    
    enum Colors {
        static let border = "border"
        static let labelText = "labelText"
        static let textRed = "textRed"
        static let iconColor = "iconColor"
        static let sliderActive = "sliderActive"
        static let sliderUnactive = "sliderUnactive"
        static let progressBarSet = "progressBarSet"
        static let progressBarRest = "progressBarRest"
        static let buttonActive = "Buttons/active"
        static let buttonNext = "Buttons/next"
        static let buttonOnceMore = "Buttons/onceMore"
        static let buttonText = "Buttons/text"
        static let buttonUnactive = "Buttons/unactive"
        static let setupButtonBackgroundEquipmentActive = "SetupButtonBackground/Equipment/active"
        static let setupButtonBackgroundEquipmentUnactive = "SetupButtonBackground/Equipment/unactive"
        static let setupButtonBackgroundTargetAreaActive = "SetupButtonBackground/TargetArea/active"
        static let setupButtonBackgroundTargetAreaUnactive = "SetupButtonBackground/TargetArea/unactive"
        static let setupButtonBackgroundWorkoutTypeActive = "SetupButtonBackground/WorkoutType/active"
        static let setupButtonBackgroundWorkoutTypeUnactive = "SetupButtonBackground/WorkoutType/unactive"
        static let recomendationBackground = "recomendationBackground"
        static let recomendationTitle = "recomendationTitle"
    }
    
}
