Class {
	#name : #GeoViewBlocBasicSample,
	#superclass : #GeoViewBlocSample,
	#instVars : [
		'geoCircle1',
		'geoCircle2',
		'geoText1',
		'geoRectangle1',
		'geoLine1',
		'geoPolygon1',
		'geoPolyline1',
		'geoSector1',
		'geoSegment1',
		'geoEllipse1',
		'geoArcBand1'
	],
	#category : #'GeoView-Bloc-Examples'
}

{ #category : #running }
GeoViewBlocBasicSample class >> start [
	<script: 'self start'>
	super start: self new.
]

{ #category : #initialization }
GeoViewBlocBasicSample >> configureGeoViewManager: aGeoViewManager [
	"create a layer with GeoCircle processdata"

	| layer1 |
	super configureGeoViewManager: aGeoViewManager.
	
	layer1 := aGeoViewManager createAndAddGeoObjectLayer: #layer1.
	layer1 setProcessData: GeoCircleProcessData new for: GeoCircle.
	layer1 setProcessData: GeoEllipseProcessData new for: GeoEllipse.
	layer1 setProcessData: GeoPolygonProcessData new for: GeoPolygon.
	layer1 setProcessData: GeoPolylineProcessData new for: GeoPolyline.
	layer1 setProcessData: GeoRectangleProcessData new for: GeoRectangle.
	layer1 setProcessData: GeoTextProcessData new for: GeoText.
	layer1 setProcessData: GeoArcBandProcessData new for: GeoArcBand.
	
]

{ #category : #initialization }
GeoViewBlocBasicSample >> createGeographicSituation: aGeoViewManager [
	"create a Geographic situation and add it into the geographic view"
	
	
	aGeoViewManager addGeoObject: (self geoCircle1: 1).
	aGeoViewManager addGeoObject: (self geoCircle2: 2).
	"aGeoplotManager addGeoObject: (self geoText1: 3).
	aGeoplotManager addGeoObject: (self geoRectangle1: 4).
	aGeoplotManager addGeoObject: (self geoPolyline1: 5).
	aGeoplotManager addGeoObject: (self geoPolygon1: 6).
	aGeoplotManager addGeoObject: (self geoEllipse1: 7).
	aGeoplotManager addGeoObject: (self geoArcBand1: 8)."
]

{ #category : #running }
GeoViewBlocBasicSample >> doGeoViewUpdate [

	| random |
	random := Random new.

	geoCircle2 isVisible: geoCircle2 isVisible not.
	geoviewManager updateGeoObject: geoCircle2.

	geoCircle1 absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: -70 + (random next * 10) longitudeInDegrees: -150 + (random next * 20)).
	"geoCircle1 radiusInMeters: 1e5 + (random next * 500)."
	geoviewManager updateGeoObject: geoCircle1.
	
	"geoText1 absolutePosition: (AbsoluteCoordinates latitudeInRadian: (-50 + (random next * 20)) longitudeInRadian: (-100 + (random next * 50))).
	geoText1 text: Time now asString. 
	geoplotManager updateGeoObject: geoText1.
	
	geoRectangle1 absolutePosition: (AbsoluteCoordinates latitudeInRadian: (200 + (random next * 50)) longitudeInRadian: (300 + (random next * 100))).
	geoRectangle1 lengthInMeters1: (random next * 100).
	geoRectangle1 lengthInMeters2: (random next * 100).
		geoRectangle1 strokeColor = Color green 
		ifTrue:  
			[ geoRectangle1 strokeColor: Color yellow.
			geoRectangle1 fillColor: (Color r: 200 g:200 b: 200) ]
		ifFalse: 
			[ geoRectangle1 strokeColor: Color green.
			geoRectangle1 fillColor: Color darkGray ].
	geoplotManager updateGeoObject: geoRectangle1.
	
	geoPolyline1 absolutePositions: 
		{ AbsoluteCoordinates 
			latitudeInRadian: 40 + (random next * 15) 
			longitudeInRadian: 300 + (random next * 10).
		AbsoluteCoordinates 
			latitudeInRadian: 75 + (random next * 5) 
			longitudeInRadian: 300 + (random next * 40).
		AbsoluteCoordinates 
			latitudeInRadian: 100 + (random next * 5) 
			longitudeInRadian: 300 + (random next * 10).
		AbsoluteCoordinates 
			latitudeInRadian: 100 + (random next * 10) 
			longitudeInRadian: 350 + (random next * 15).
		AbsoluteCoordinates 
			latitudeInRadian: 60 + (random next * 10) 
			longitudeInRadian: 340 + (random next * 35). }.
	geoplotManager updateGeoObject: geoPolyline1.
	
	geoPolygon1 absolutePositions: 
		{ AbsoluteCoordinates 
			latitudeInRadian: 40 + (random next * 15) 
			longitudeInRadian: 400 + (random next * 10).
		AbsoluteCoordinates 
			latitudeInRadian: 75 + (random next * 5) 
			longitudeInRadian: 400 + (random next * 30).
		AbsoluteCoordinates 
			latitudeInRadian: 100 + (random next * 5) 
			longitudeInRadian: 400 + (random next * 10).
		AbsoluteCoordinates 
			latitudeInRadian: 100 + (random next * 30) 
			longitudeInRadian: 450 + (random next * 15).
		AbsoluteCoordinates 
			latitudeInRadian: 60 + (random next * 10) 
			longitudeInRadian: 450 + (random next * 15). }.
	geoplotManager updateGeoObject: geoPolygon1.
	
	geoEllipse1 absolutePosition: (AbsoluteCoordinates latitudeInRadian: (350 + (random next * 50)) longitudeInRadian: (50 + (random next * 100))).
	geoEllipse1 radiusInMeters1: random next * 50.
	geoEllipse1 radiusInMeters2: random next * 50.
	geoplotManager updateGeoObject: geoEllipse1.
	
	geoArcBand1 apertureInRadians: random next * 2 * Float pi.
	geoArcBand1 orientationInAzimuths: random next * 2 * Float pi.
	geoplotManager updateGeoObject: geoArcBand1."
	
	^true
]

{ #category : #'geo objects' }
GeoViewBlocBasicSample >> geoArcBand1: aKey [
	geoArcBand1
		ifNil: [ geoArcBand1 := GeoArcBand new.
			geoArcBand1 key: aKey.
			geoArcBand1 absoluteCoordinates: (AbsoluteCoordinates latitudeInRadians: 400 longitudeInRadians: 400).
			geoArcBand1 fillColor: Color brown.
			geoArcBand1 radiusInMeters1: 30.
			geoArcBand1 radiusInMeters2: 60.
			geoArcBand1 orientationInAzimuths: 90.
			geoArcBand1 apertureInRadians: Float pi / 2. ].
	^ geoArcBand1
]

{ #category : #'geo objects' }
GeoViewBlocBasicSample >> geoCircle1: aKey [
	geoCircle1
		ifNil: [ geoCircle1 := GeoCircle new.
			geoCircle1 key: aKey.
			geoCircle1 absoluteCoordinates: (AbsoluteCoordinates 
				latitudeInDegrees: -70 
				longitudeInDegrees: -150).
			geoCircle1 fillColor: Color red.
			geoCircle1 radiusInMeters: 1e6 ].
	^ geoCircle1
]

{ #category : #'geo objects' }
GeoViewBlocBasicSample >> geoCircle2: aKey [
	geoCircle2
		ifNil: [ geoCircle2 := GeoCircle new.
			geoCircle2 key: aKey.
			geoCircle2 absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 20 longitudeInDegrees: 100).
			geoCircle2 fillColor: Color blue.
			geoCircle2 radiusInMeters: 25 ].
	^ geoCircle2
]

{ #category : #'geo objects' }
GeoViewBlocBasicSample >> geoEllipse1: aKey [
	geoEllipse1
		ifNil: [ geoEllipse1 := GeoEllipse new.
			geoEllipse1 key: aKey.
			geoEllipse1 absoluteCoordinates: 
				(AbsoluteCoordinates latitudeInDegrees: -50 longitudeInDegrees: 100).
			geoEllipse1 fillColor: Color lightBlue.
			geoEllipse1 strokeColor: Color darkGray.
			geoEllipse1 strokeWidth: 1.
			geoEllipse1 radiusInMeters1: 75.
			geoEllipse1 radiusInMeters2: 25.
			
			].
	^ geoEllipse1
]

{ #category : #'geo objects' }
GeoViewBlocBasicSample >> geoPolygon1: aKey [
	geoPolygon1
		ifNil: [ geoPolygon1 := GeoPolygon new.
			geoPolygon1 key: aKey.
			geoPolygon1 absolutePositions: 
				{AbsoluteCoordinates latitudeInDegrees: 50 longitudeInDegrees: 400.
				AbsoluteCoordinates latitudeInDegrees: 75 longitudeInDegrees: 410.
				AbsoluteCoordinates latitudeInDegrees: 100 longitudeInDegrees: 400.
				AbsoluteCoordinates latitudeInDegrees: 100 longitudeInDegrees: 450.
				AbsoluteCoordinates latitudeInDegrees: 60 longitudeInDegrees: 445}.
			geoPolygon1 fillColor: (Color blue alpha: 0.5).
			geoPolygon1 strokeColor: Color blue.
			geoPolygon1 strokeWidth: 1].
	^ geoPolygon1
]

{ #category : #'geo objects' }
GeoViewBlocBasicSample >> geoPolyline1: aKey [
	geoPolyline1
		ifNil: [ geoPolyline1 := GeoPolyline new.
			geoPolyline1 key: aKey.
			geoPolyline1 absolutePositions: 
				{AbsoluteCoordinates latitudeInDegrees: 50 longitudeInDegrees: 300.
				AbsoluteCoordinates latitudeInDegrees: 75 longitudeInDegrees: 310.
				AbsoluteCoordinates latitudeInDegrees: 100 longitudeInDegrees: 300.
				AbsoluteCoordinates latitudeInDegrees: 100 longitudeInDegrees: 350.
				AbsoluteCoordinates latitudeInDegrees: 60 longitudeInDegrees: 345}.
			geoPolyline1 fillColor: (Color red alpha: 0.5).
			geoPolyline1 strokeColor: Color black.
			geoPolyline1 strokeWidth: 1].
	^ geoPolyline1
]

{ #category : #'geo objects' }
GeoViewBlocBasicSample >> geoRectangle1: aKey [
	geoRectangle1
		ifNil: [ geoRectangle1 := GeoRectangle new.
			geoRectangle1 key: aKey.
			geoRectangle1 absoluteCoordinates: 
				(AbsoluteCoordinates latitudeInDegrees: 100 longitudeInDegrees: 200).
			geoRectangle1 fillColor: Color gray.
			geoRectangle1 strokeColor: Color green.
			geoRectangle1 strokeWidth: 4.
			geoRectangle1 lengthInMeters1: 100.
			geoRectangle1 lengthInMeters2: 150 ].
	^ geoRectangle1
]

{ #category : #'geo objects' }
GeoViewBlocBasicSample >> geoSector1: aKey [
	geoSector1
		ifNil: [ geoSector1 ":= GeoSector new".
			geoSector1 key: aKey.
			geoSector1 absoluteCoordinates: 
				(AbsoluteCoordinates latitudeInDegrees: 400 longitudeInDegrees: 100).
			geoSector1 fillColor: Color yellow.
			
			].
	^ geoSector1
]

{ #category : #'geo objects' }
GeoViewBlocBasicSample >> geoSegment1: aKey [
	geoSegment1
		ifNil: [ geoSegment1 ":= GeoSegment new".
			geoSegment1 key: aKey.
			geoSegment1 absoluteCoordinates: 
				(AbsoluteCoordinates latitudeInDegrees: 400 longitudeInDegrees: 100).
			geoSegment1 fillColor: Color yellow.
			
			].
	^ geoSegment1
]

{ #category : #'geo objects' }
GeoViewBlocBasicSample >> geoText1: aKey [
	geoText1
		ifNil: [ geoText1 := GeoText new.
			geoText1 key: aKey.
			geoText1 absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: 150 longitudeInDegrees: 150).
			geoText1 fillColor: Color pink.
			geoText1 fontSize: 12.
			geoText1 text: 'I am a GeoText' ].
	^ geoText1
]
