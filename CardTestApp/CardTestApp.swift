//
//  CardTestAppApp.swift
//  CardTestApp
//
//  Created by Graham Reeves on 29/11/2024.
//

import SwiftUI


//	always run in edgy dark mode
let forceColourScheme : ColorScheme? = .light


@main
struct CardTestApp: App
{
	var body: some Scene
	{
		WindowGroup
		{
			ContentView()
				.preferredColorScheme(forceColourScheme)
				.frame(minWidth: 0,minHeight: 0)
		}
	}
}

