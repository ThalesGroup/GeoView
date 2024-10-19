"
A GeoPolygonTest is a test class for testing the behavior of GeoPolygon
"
Class {
	#name : #GeoPolygonTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - GeoObjects'
}

{ #category : #'tests - instance' }
GeoPolygonTest >> geoPolygon1 [

	^ GeoPolygon new
		isVisible: true;
		key: #polyline1;
		fillStyle: Color black asSmockFillStyle;
		strokeStyle: (Color red asSmockStrokeStyle width: 1);
		absolutePositions: {
			AbsoluteCoordinates latitudeInRadians: 0.1 longitudeInRadians: 0.2.
			AbsoluteCoordinates latitudeInRadians: 0.2 longitudeInRadians: 0.3.
			AbsoluteCoordinates latitudeInRadians: 0.3 longitudeInRadians: 0.4.
		};
		yourself.
]

{ #category : #'tests - instance' }
GeoPolygonTest >> geoPolygon2 [

	^ GeoPolygon new
		isVisible: false;
		key: #polyline2;
		fillStyle: Color black asSmockFillStyle;
		strokeStyle: (Color red asSmockStrokeStyle width: 2);
		absolutePositions: {
			AbsoluteCoordinates latitudeInRadians: 0.3 longitudeInRadians: 0.2.
			AbsoluteCoordinates latitudeInRadians: 0.2 longitudeInRadians: 0.1.
			AbsoluteCoordinates latitudeInRadians: 0.1 longitudeInRadians: 0.0.
			AbsoluteCoordinates latitudeInRadians: 0.4 longitudeInRadians: 0.4.
		};
		yourself.
]

{ #category : #tests }
GeoPolygonTest >> testCopy [
	| geoPolygon geoPolygonCopy |
	geoPolygon := self geoPolygon1.
	geoPolygonCopy := geoPolygon copy.

	self assert: geoPolygon absolutePositions size equals: geoPolygonCopy absolutePositions size.
	1 to: geoPolygon absolutePositions size do: [ :i | | pos1 pos2 |
		pos1 := geoPolygon absolutePositions at: i.
		pos2 := geoPolygonCopy absolutePositions at: i.
		self assert: pos1 equals: pos2.
		self assert: pos1 ~~ pos2.
	].
]

{ #category : #tests }
GeoPolygonTest >> testUpdateWith [

	| geoPolygon1 geoPolygon2 |
	geoPolygon1 := self geoPolygon1.
	geoPolygon2 := self geoPolygon2.
	
	self assert: geoPolygon1 absolutePositions size ~= geoPolygon2 absolutePositions size.
	1 to: geoPolygon1 absolutePositions size do: [ :i | | pos1 pos2 |
		pos1 := geoPolygon1 absolutePositions at: i.
		pos2 := geoPolygon2 absolutePositions at: i.
		self assert: pos1 ~= pos2.
	].
	
	geoPolygon1 updateWith: geoPolygon2.
	
	self assert: geoPolygon1 absolutePositions size equals: geoPolygon2 absolutePositions size.
	1 to: geoPolygon1 absolutePositions size do: [ :i | | pos1 pos2 |
		pos1 := geoPolygon1 absolutePositions at: i.
		pos2 := geoPolygon2 absolutePositions at: i.
		self assert: pos1 equals: pos2.
		self assert: pos1 ~~ pos2.
	].
]
