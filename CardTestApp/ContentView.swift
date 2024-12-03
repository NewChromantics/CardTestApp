//
//  ContentView.swift
//  CardTestApp
//
//  Created by Graham Reeves on 29/11/2024.
//

import SwiftUI
import Cards

struct ContentView: View
{
	let suits =
	[
		CardSuit.club,
		CardSuit.spade,
		CardSuit.diamond,
		CardSuit.heart,
		"bolt.fill",
		"moon.fill",
		"star.fill",
		"arrowshape.left.fill",
		"baseball.fill",
		"clipboard.fill",
		"leaf.fill",
		"cloud.drizzle.fill",
		"powerplug.portrait.fill",
		"sun.max.fill",
		"rainbow",
	]
	let values = Array( 0...17 )
	
	var body: some View
	{
		let spacing = 5.0
		VStack(spacing:spacing)
		{
			ForEach(0..<9, id:\.self)
			{
				cardRow in
				HStack(spacing:spacing)
				{
					ForEach(0..<20, id:\.self)
					{
						_ in
						var suit : String = suits.randomElement() ?? suits[0]
						let value = values.randomElement() ?? values[0]
						let null = Int.random(in: 0...4) == 0
						let cardValue = null ? nil : CardMeta( value, suit )
						InteractiveCard(cardMeta: cardValue)
						//CardView(cardMeta:cardValue)
					}
				}
			}
		}
		.frame(maxWidth: .infinity,maxHeight: .infinity)
		.padding(50)
		.background(Color("Felt"))
	}
}

#Preview {
	ContentView()
}

