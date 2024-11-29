//
//  ContentView.swift
//  CardTestApp
//
//  Created by Graham Reeves on 29/11/2024.
//

import SwiftUI

struct ContentView: View
{
	let cards = [
		CardMeta(value:2,suit: Card.Suit.heart),
		CardMeta(value:3,suit: Card.Suit.diamond),
		CardMeta(value:5,suit: Card.Suit.spade),
		CardMeta(value:7,suit: Card.Suit.club),
		CardMeta(value:.jack,suit: Card.Suit.spade),
		CardMeta(value:.queen,suit: Card.Suit.spade),
		CardMeta(value:.king,suit: Card.Suit.spade),
		CardMeta(value:.ace,suit: Card.Suit.spade),
		CardMeta("TH"),
		CardMeta("1D"),
		CardMeta("5S"),
		CardMeta("QC"),
	]

	var body: some View
	{
		HStack
		{
			ForEach(cards, id:\.self)
			{
				cardValue in
				Card(cardMeta: cardValue)
			}
		}
	}
}

#Preview {
	ContentView()
}

