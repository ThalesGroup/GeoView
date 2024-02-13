"
A GeoPolylineTest is a test class for testing the behavior of GeoPolyline
"
Class {
	#name : #GeoPolylineTest,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - GeoObject'
}

{ #category : #'tests - instance' }
GeoPolylineTest >> geoPolyline1 [

	^ GeoPolyline new
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
GeoPolylineTest >> geoPolyline2 [

	^ GeoPolyline new
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
GeoPolylineTest >> testCopy [
	| geoPolyline geoPolylineCopy |
	geoPolyline := self geoPolyline1.
	geoPolylineCopy := geoPolyline copy.

	self assert: geoPolyline absolutePositions size equals: geoPolylineCopy absolutePositions size.
	1 to: geoPolyline absolutePositions size do: [ :i | | pos1 pos2 |
		pos1 := geoPolyline absolutePositions at: i.
		pos2 := geoPolylineCopy absolutePositions at: i.
		self assert: pos1 equals: pos2.
		self assert: pos1 ~~ pos2.
	].
]

{ #category : #tests }
GeoPolylineTest >> testUpdateWith [

	| geoPolyline1 geoPolyline2 |
	geoPolyline1 := self geoPolyline1.
	geoPolyline2 := self geoPolyline2.
	
	self assert: geoPolyline1 absolutePositions size ~= geoPolyline2 absolutePositions size.
	1 to: geoPolyline1 absolutePositions size do: [ :i | | pos1 pos2 |
		pos1 := geoPolyline1 absolutePositions at: i.
		pos2 := geoPolyline2 absolutePositions at: i.
		self assert: pos1 ~= pos2.
	].
	
	geoPolyline1 updateWith: geoPolyline2.
	
	self assert: geoPolyline1 absolutePositions size equals: geoPolyline2 absolutePositions size.
	1 to: geoPolyline1 absolutePositions size do: [ :i | | pos1 pos2 |
		pos1 := geoPolyline1 absolutePositions at: i.
		pos2 := geoPolyline2 absolutePositions at: i.
		self assert: pos1 equals: pos2.
		self assert: pos1 ~~ pos2.
	].
]
