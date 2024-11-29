//
//  ContentView.swift
//  CardTestApp
//
//  Created by Graham Reeves on 29/11/2024.
//

import SwiftUI

struct ContentView: View
{
	let suits =
	[
		Card.Suit.club,
		Card.Suit.spade,
		Card.Suit.diamond,
		Card.Suit.heart,
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
			ForEach(0..<7, id:\.self)
			{
				cardRow in
				HStack(spacing:spacing)
				{
					ForEach(0..<25, id:\.self)
					{
						_ in
						let suit = suits.randomElement() ?? suits[0]
						let value = values.randomElement() ?? values[0]
						let cardValue = CardMeta(value,suit)
						InteractiveCard(cardMeta: cardValue)
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

