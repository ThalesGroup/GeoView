"
A GeoTextTest is a test class for testing the behavior of GeoText
"
Class {
	#name : #GeoTextTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - GeoObject'
}

{ #category : #'tests - instance' }
GeoTextTest >> geoText1 [

	^ GeoText new
		absoluteCoordinates: AbsoluteCoordinates zero;
		isVisible: true;
		key: #text1;
		fillColor: Color black;
		strokeColor: Color red;
		strokePattern: nil;
		strokeWidth: 1;
		fontName: 'Arial';
		fontEmphasis: GeoFontAttributes fontEmphasisNormal;
		fontWeight: GeoFontAttributes fontWeightNormal;
		fontSize: 12;
		text: 'Hello !'
		yourself.
]

{ #category : #'tests - instance' }
GeoTextTest >> geoText2 [

	^ GeoText new
		absoluteCoordinates: (AbsoluteCoordinates latitudeInRadians: 0.5 longitudeInRadians: 0.5);
		isVisible: false;
		key: #text2;
		fillColor: Color white;
		strokeColor: Color blue;
		strokePattern: nil;
		strokeWidth: 2;
		fontName: 'times new roman';
		fontEmphasis: GeoFontAttributes fontEmphasisItalic;
		fontWeight: GeoFontAttributes fontWeightBold;
		fontSize: 16;
		text: 'Hello world!';
		yourself.
]

{ #category : #tests }
GeoTextTest >> testCopy [

	| geoText geoTextCopy |
	geoText := self geoText1.
	geoTextCopy := geoText copy.
	
	self assert: geoText text equals: geoTextCopy text.
	self assert: geoText fontName equals: geoTextCopy fontName.
	self assert: geoText fontSize equals: geoTextCopy fontSize.
	self assert: geoText fontEmphasis equals: geoTextCopy fontEmphasis.
	self assert: geoText fontWeight equals: geoTextCopy fontWeight.
]

{ #category : #tests }
GeoTextTest >> testUpdateWith [

	| geoText1 geoText2 |
	geoText1 := self geoText1.
	geoText2 := self geoText2.
	
	self assert: geoText1 text ~= geoText2 text.
	self assert: geoText1 fontName ~= geoText2 fontName.
	self assert: geoText1 fontSize ~= geoText2 fontSize.
	self assert: geoText1 fontEmphasis ~= geoText2 fontEmphasis.
	self assert: geoText1 fontWeight ~= geoText2 fontWeight.
	
	geoText1 updateWith: geoText2.
	
	self assert: geoText1 text equals: geoText2 text.
	self assert: geoText1 fontName equals: geoText2 fontName.
	self assert: geoText1 fontSize equals: geoText2 fontSize.
	self assert: geoText1 fontEmphasis equals: geoText2 fontEmphasis.
	self assert: geoText1 fontWeight equals: geoText2 fontWeight.
]
