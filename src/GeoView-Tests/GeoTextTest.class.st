"
A GeoTextTest is a test class for testing the behavior of GeoText
"
Class {
	#name : #GeoTextTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-GeoObjects'
}

{ #category : #'tests - instance' }
GeoTextTest >> geoText1 [

	^ GeoText new
		absoluteCoordinates: AbsoluteCoordinates zero;
		isVisible: true;
		key: #text1;
		fillStyle: Color black asSmockFillStyle;
		strokeStyle: (Color red asSmockStrokeStyle width: 2);
		smockFont: ((SmockFont named: 'Arial') fontSize: 12);
		text: 'Hello !'
		yourself.
]

{ #category : #'tests - instance' }
GeoTextTest >> geoText2 [

	^ GeoText new
		absoluteCoordinates: (AbsoluteCoordinates latitudeInRadians: 0.5 longitudeInRadians: 0.5);
		isVisible: false;
		key: #text2;
		fillStyle: Color black asSmockFillStyle;
		strokeStyle: (Color red asSmockStrokeStyle width: 2);
		smockFont: ((SmockFont named: 'times new roman') fontSize: 16; fontWeight: #bold; fontStretch: #italic);
		text: 'Hello world!';
		yourself.
]

{ #category : #tests }
GeoTextTest >> testCopy [

	| geoText geoTextCopy |
	geoText := self geoText1.
	geoTextCopy := geoText copy.
	
	self assert: geoText text equals: geoTextCopy text.
	self assert: geoText smockFont equals: geoTextCopy smockFont.
]

{ #category : #tests }
GeoTextTest >> testUpdateWith [

	| geoText1 geoText2 |
	geoText1 := self geoText1.
	geoText2 := self geoText2.
	
	self assert: geoText1 text ~= geoText2 text.
	self assert: geoText1 smockFont ~= geoText2 smockFont.
	
	geoText1 updateWith: geoText2.
	
	self assert: geoText1 text equals: geoText2 text.
	self assert: geoText1 smockFont equals: geoText2 smockFont.
]
