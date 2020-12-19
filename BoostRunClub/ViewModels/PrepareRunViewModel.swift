//
//  PrepareRunViewModel.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/11/24.
//

import Combine
import CoreLocation
import Foundation

protocol PrepareRunViewModelTypes: AnyObject {
    var inputs: PrepareRunViewModelInputs { get }
    var outputs: PrepareRunViewModelOutputs { get }
}

protocol PrepareRunViewModelInputs {
    func didTapShowProfileButton()
    func didTapSetGoalButton()
    func didTapStartButton()
    func didChangeGoalType(_ goalType: GoalType)
    func didChangeGoalValue(_ goalValue: String?)
    func didTapGoalValueButton()
    func countDownAnimationFinished()
}

protocol PrepareRunViewModelOutputs {
    var userLocationSubject: PassthroughSubject<CLLocationCoordinate2D, Never> { get }
    var goalTypeSubject: CurrentValueSubject<GoalType, Never> { get }
    // TODO: - GoalType/value observable을 goalInfo로 바꿀지 생각해보기
    var goalValueSubject: CurrentValueSubject<String, Never> { get }
    var goalValueSetupClosed: PassthroughSubject<Void, Never> { get }
    var goalTypeSetupClosed: PassthroughSubject<Void, Never> { get }
    var showGoalTypeActionSheetSignal: PassthroughSubject<GoalType, Never> { get }
    var showGoalValueSetupSceneSignal: PassthroughSubject<GoalInfo, Never> { get }
    var showRunningSceneSignal: PassthroughSubject<GoalInfo, Never> { get }
    var countDownAnimation: PassthroughSubject<Void, Never> { get }
    var showProfileSignal: PassthroughSubject<Void, Never> { get }
}

class PrepareRunViewModel: PrepareRunViewModelInputs, PrepareRunViewModelOutputs {
    let locationProvider: LocationProvidable

    var cancellables = Set<AnyCancellable>()
    private var goalInfo: GoalInfo {
        GoalInfo(
            type: goalTypeSubject.value,
            value: goalValueSubject.value
        )
    }

    init(locationProvider: LocationProvidable) {
        self.locationProvider = locationProvider
        locationProvider.locationSubject
            .compactMap { $0.coordinate }
            .sink { [weak self] in self?.userLocationSubject.send($0) }
            .store(in: &cancellables)
    }

    deinit {
        print("[Memory \(Date())] 🌙ViewModel⭐️ \(Self.self) deallocated.")
    }

    // MARK: Inputs

    func didTapShowProfileButton() {
        showProfileSignal.send()
    }

    func didTapSetGoalButton() {
        showGoalTypeActionSheetSignal.send(goalTypeSubject.value)
    }

    func didTapStartButton() {
        countDownAnimation.send()
    }

    func didTapGoalValueButton() {
        showGoalValueSetupSceneSignal.send(goalInfo)
    }

    func didChangeGoalType(_ goalType: GoalType) {
        if goalType != goalTypeSubject.value {
            goalTypeSubject.send(goalType)
            goalValueSubject.send(goalType.initialValue)
            if goalType != .none {
                goalTypeSetupClosed.send()
            }
        }
    }

    func didChangeGoalValue(_ goalValue: String?) {
        goalValueSetupClosed.send()
        if let goalValue = goalValue {
            goalValueSubject.send(goalValue)
        }
    }

    func countDownAnimationFinished() {
        showRunningSceneSignal.send(goalInfo)
    }

    // MARK: Outputs

    var goalTypeSubject = CurrentValueSubject<GoalType, Never>(.none)
    var goalValueSubject = CurrentValueSubject<String, Never>("")
    var goalValueSetupClosed = PassthroughSubject<Void, Never>()
    var goalTypeSetupClosed = PassthroughSubject<Void, Never>()

    var userLocationSubject = PassthroughSubject<CLLocationCoordinate2D, Never>()

    var countDownAnimation = PassthroughSubject<Void, Never>()

    var showGoalTypeActionSheetSignal = PassthroughSubject<GoalType, Never>()
    var showGoalValueSetupSceneSignal = PassthroughSubject<GoalInfo, Never>()
    var showRunningSceneSignal = PassthroughSubject<GoalInfo, Never>()
    var showProfileSignal = PassthroughSubject<Void, Never>()
}

// MARK: - Types

extension PrepareRunViewModel: PrepareRunViewModelTypes {
    var inputs: PrepareRunViewModelInputs { self }
    var outputs: PrepareRunViewModelOutputs { self }
}
