import SwiftUI

extension StringProtocol
{
	subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
	subscript(range: Range<Int>) -> SubSequence {
		let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
		return self[startIndex..<index(startIndex, offsetBy: range.count)]
	}
	subscript(range: ClosedRange<Int>) -> SubSequence {
		let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
		return self[startIndex..<index(startIndex, offsetBy: range.count)]
	}
	subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
	subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
	subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}



//	https://www.swiftbysundell.com/articles/switching-between-swiftui-hstack-vstack/
struct IconStack<Content: View>: View
{
	//var horizontalAlignment = HorizontalAlignment.center
	//var verticalAlignment = VerticalAlignment.top
	//var spacing: CGFloat?
	var iconCount : Int
	@ViewBuilder var content: () -> Content
	
	var body: some View
	{
		//	layout is 3 columns
		//	<4 all in center
		//	other wise edge and remainder in middle
		let columnRows : [Int] = {
			if iconCount == 1
			{
				return [1]
			}
			else if iconCount < 4
			{
				return [0,iconCount,0]
			}
			else if iconCount > 6 || (iconCount%2)==1
			{
				//	when odd number
				//	put more on the outside but even up
				var side = iconCount/3
				var remain = (iconCount - side - side) % iconCount
				if remain >= side && remain > 1
				{
					remain -= 2
					side += 1
				}
				return [side,remain,side]
			}
			else
			{
				let side = iconCount/2
				let remain = (iconCount - side - side) % iconCount
				return [side,remain,side]
			}
		}()
		
		let iconSpacing = 2.0
		
		HStack(spacing:iconSpacing)
		{
			ForEach(columnRows, id:\.self)
			{
				rowCount in
				VStack(spacing:iconSpacing)
				{
					let rows = max(0,rowCount)
					ForEach(0..<rows)
					{_ in
						content()
							//	fill column so items dont bunch in middle
							.frame(maxHeight: .infinity)
							//.background(.blue)
					}
					if rows == 0
					{
						//Text("x")
						Spacer()
					}
				}
				//	forces equal width
				.frame(minWidth: 0, maxWidth: .infinity)
				//.background(.yellow)
			}
		}
		//.frame(minWidth: 0, maxWidth: .infinity)
	}
}



typealias CardValue = Int

extension CardValue
{
	static let t = CardValue(10)
	static let jack = CardValue(11)
	static let queen = CardValue(12)
	static let king = CardValue(13)
	static let ace = CardValue(1)
}

extension CardValue : ExpressibleByIntegerLiteral
{
	init(integerLiteral value: Int) {
		self = CardValue(value)
	}
}

//	we can't use CustomStringConvertible, but we can just override .description
extension CardValue //: CustomStringConvertible
{
	var description: String
	{
		switch self
		{
			case .jack:	return "J"
			case .queen:	return "Q"
			case .king:	return "K"
			case .ace:	return "A"
			default:	return String(self)
		}
	}
}

extension CardValue : ExpressibleByStringLiteral
{
	public init(stringLiteral value: String) /*throws*/
	{
		switch value
		{
			case "T":	self.init(CardValue.t)
			case "J":	self.init(CardValue.jack)
			case "Q":	self.init(CardValue.queen)
			case "K":	self.init(CardValue.king)
			case "A":	self.init(CardValue.ace)
			//default:	return nil
			default:	self = 0
		}
	}
}

/*
//	card values can be numbers or strings (A,K,Q,J etc)
enum CardValue : Int, /*RawRepresentable, Equatable, Hashable, CaseIterable, */CustomStringConvertible
{
	var description: String	{	String(self.rawValue)	}
	
	typealias RawValue = Int
	
	//case int(Int)
	
case ten = 10
case jack = 11
case queen = 12
case king = 13
case ace = 1
	/*
	//static let ten = CardValue(10)
	static let jack = CardValue(11)
	static let queen = CardValue(12)
	static let king = CardValue(13)
	static let ace = CardValue(1)
	
	static let T = ten
	static let J = jack
	static let Q = queen
	static let K = king
	static let A = ace
	
	var string : String	{	String(self.hashValue)	}
	
	static func getValue(_ code:String) -> CardValue
	{
		if ( code == "T" )	{	return T	}
		if ( code == "J" )	{	return J	}
		if ( code == "Q" )	{	return Q	}
		if ( code == "K" )	{	return K	}
		if ( code == "A" )	{	return A	}
		//throw RuntimeError("Unknown \(code)")
		return CardValue(-1)
	}
	*/
}

extension CardValue : ExpressibleByIntegerLiteral
{
	init(integerLiteral value: Int) {
		self = CardValue(rawValue:value)
	}
}
/*
extension CardValue : ExpressibleByStringLiteral
{
	init(stringLiteral value: String) {
		self = CardValue.getValue(value)
	}
}
*/
*/


struct CardMeta : Hashable
{
	var value : CardValue
	var suit : String
	
	//	shorthand for QH (queen heart)
	init(_ valueAndSuit:String)
	{
		if valueAndSuit.count != 2
		{
			//throw RuntimeError("CardMeta code needs to be 2 chars Value|Suit")
		}
		let v = String(valueAndSuit[0])
		self.value = CardValue(stringLiteral: v)
		self.suit = String(valueAndSuit[1])
	}
		
	
	init(value: CardValue, suit: String)
	{
		self.value = value
		self.suit = suit
	}
	
	init(_ value: Int, _ suit: String)
	{
		self.value = CardValue(integerLiteral:value)
		self.suit = suit
	}
}

#if !canImport(UIKit)
typealias UIColor = NSColor
#endif

//	add extensions to this...
//	does it need to be an enum?
extension Card.Suit
{
	static func GetDefaultColourFor(suit:String) -> Color?
	{
		if let assetColour = UIColor(named:suit)
		{
			return Color(assetColour)
		}
		return nil
	}
}



struct Card : View
{
	class Suit
	{
		static let heart = "suit.heart.fill"
		static let spade = "suit.spade.fill"
		static let club = "suit.club.fill"
		static let diamond = "suit.diamond.fill"
	}
	
	//var cardMeta : CardMeta	{	CardMeta(value: value, suit: suit)	}
	//var value : CardValue
	//var suit : String = Suit.club	//	sf symbol
	var cardMeta : CardMeta
	var value : CardValue { cardMeta.value }
	var suit : String { cardMeta.suit }
	//var suitSystemImageName : String	{	return "suit.\(suit).fill"	}
	var suitSystemImageName : String	{	return suit	}
	var pip : Image 	{ Image(systemName:suitSystemImageName)	}

	var faceUp = true
	
	var backing : Color { suitColour }	//	todo: turn into a view or repeating image
	var suitColour : Color { customSuitColour ?? defaultSuitColour ?? Color.blue }
	var customSuitColour : Color?
	var defaultSuitColour : Color? { Card.Suit.GetDefaultColourFor(suit: suit) }
	var paperColour = Color("Paper")
	var paperEdgeColour = Color.gray //: Color { paperColour }
	
	let width = 80.0
	let heightRatio = 1.4//1.4 is real card
	var height : CGFloat {	width * heightRatio	}
	var cornerRadius : CGFloat { width * 0.09 }
	var paperBorder : CGFloat { width * 0.05 }
	var borderWidth : CGFloat { 0.5 }
	var pipMinWidth : CGFloat { 8 }
	var pipWidth : CGFloat { max( pipMinWidth, width * 0.10) }
	var pipHeight : CGFloat { pipWidth }
	var shadowSofteness : CGFloat	{ 0.80	}//0..1
	var shadowRadius : CGFloat	{ depth / (10.0 * (1.0-shadowSofteness) ) }
	var shadowSize : CGFloat { depth }

	var innerBorderCornerRadius : CGFloat { width * 0.05 }
	//var innerBorderColour : Color { Color.blue }
	var innerBorderColour : Color { Color.clear }
	var innerBorderPadding : CGFloat = 4

	var z : CGFloat = 4
	var minz = 1.5
	var depth : CGFloat { max(minz,z)	}
	var shadowOffset : CGFloat { depth * 1.5 }
	
	@ViewBuilder
	var pipView : some View
	{
		//	special case :)
		let multiColour = suit == "rainbow"
		
		pip
			.resizable()
			.scaledToFit()
			.foregroundStyle(suitColour/*, accentColour*/)
			.symbolRenderingMode( multiColour ? .multicolor : .monochrome )
	}
	
	var cornerPipView : some View
	{
		//	pip
		HStack(alignment: .top)
		{
			VStack(alignment:.center, spacing:0)
			{
				Text( value.description )
					.foregroundStyle(suitColour, paperEdgeColour)
					.lineLimit(1)
					.font(.system(size: pipHeight))
					.fontWeight(.bold)

				pipView
					.frame(width: pipWidth,height: pipHeight)
				
				Spacer()
			}
			Spacer()
		}
	}
	
	//	view for the center of the card
	//	either a bunch of pips, or a big image!
	@ViewBuilder
	var ValueView : some View
	{
		IconStack(iconCount:value)
		{
			pipView
		}
		.padding(innerBorderPadding)
		//.background(.green)
		.frame(maxWidth: .infinity,maxHeight: .infinity)
		//.background(.yellow)
		//.border(.blue)
		.overlay(
			RoundedRectangle(cornerRadius: innerBorderCornerRadius)
				.stroke( innerBorderColour, lineWidth: borderWidth)
		)
		.padding(innerBorderPadding)

	}
	
	var body: some View
	{
		ZStack
		{
			ValueView
				.padding(pipWidth)
			cornerPipView
			cornerPipView
				.rotationEffect(.degrees(180))
		}
		//.background(suitColour)
		.clipShape(
			RoundedRectangle(cornerRadius: cornerRadius)
		)
		//.frame(width:width,height: height)
		.padding(paperBorder)
		.background(paperColour)
		.clipShape(
			RoundedRectangle(cornerRadius: cornerRadius)
		)
		.shadow(radius: shadowRadius,x:shadowOffset,y:shadowOffset)
		.overlay(
			RoundedRectangle(cornerRadius: cornerRadius)
				.stroke(paperEdgeColour, lineWidth: borderWidth)
		)
		.offset(x:-depth,y:-depth)
		.frame(width:width,height: height)
		
	}
}


struct InteractiveCard : View
{
	var cardMeta : CardMeta
	@State var z : CGFloat = 0

	var body: some View
	{
		Card(cardMeta: cardMeta,z:z)
			.animation(.interactiveSpring, value: z)
			.onHover
		{
			over in
			self.z = over ? 10 : 0
		}
		.onLongPressGesture(minimumDuration: 1) {
			print("Long pressed!")
		} onPressingChanged:
		{
			over in
			self.z = over ? 10 : 0
		}
	}
}


#Preview {
	let cards = [
		[
			CardMeta(value:1,suit: "bolt.fill"),
			CardMeta(value:2,suit: Card.Suit.spade),
			CardMeta(value:3,suit: Card.Suit.diamond),
			CardMeta(value:1,suit: "moon.fill"),
			CardMeta(value:5,suit: "star.fill"),
			CardMeta(value:6,suit: Card.Suit.club),
		],
		[
			CardMeta(value:7,suit: Card.Suit.club),
			CardMeta(value:8,suit: "arrowshape.left.fill"),
			CardMeta(value:9,suit: Card.Suit.heart),
			CardMeta(value:.queen,suit: "baseball.fill"),
			CardMeta(value:.jack,suit: "clipboard.fill"),
			CardMeta(value:13,suit: "leaf.fill"),
		//CardMeta("TH")
		],
		[
			CardMeta(value:14,suit: "cloud.drizzle.fill"),
			CardMeta(value:15,suit: "sun.max.fill"),
			CardMeta(value:16,suit: "powerplug.portrait.fill"),
			CardMeta(value:3,suit: "sun.max.fill"),
			CardMeta(value:20,suit: "rainbow"),
			CardMeta(value:1,suit: "rainbow"),
		]
	]
	
	let spacing = 5.0
	VStack(spacing:spacing)
	{
		ForEach(cards, id:\.self)
		{
			cardRow in
			HStack(spacing:spacing)
			{
				ForEach(cardRow, id:\.self)
				{
					cardValue in
					let z = Int.random(in: 0...20)
					//InteractiveCard(cardMeta: cardValue, z:CGFloat(z))
					InteractiveCard(cardMeta: cardValue)
				}
			}
		}
	}
	.padding(50)
	.background(Color("Felt"))
}

