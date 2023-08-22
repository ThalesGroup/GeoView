Class {
	#name : #GeoViewBlocWorldOutlineForcedSample,
	#superclass : #GeoViewBlocWorldOutlineSample,
	#instVars : [
		'geoCircles'
	],
	#category : #'GeoView-Bloc-Examples'
}

{ #category : #running }
GeoViewBlocWorldOutlineForcedSample class >> mercator [
	<script: 'super mercator'>
]

{ #category : #running }
GeoViewBlocWorldOutlineForcedSample class >> transverseMercator [
	<script: 'super transverseMercator'>

]

{ #category : #initialization }
GeoViewBlocWorldOutlineForcedSample >> configureGeoViewManager: aGeoViewManager [
	"create a layer with GeoCircle processdata"

	| layer1 |
	super configureGeoViewManager: aGeoViewManager.
	"create a GeoCircle and add it into the geographic view"
	layer1 := aGeoViewManager getLayer: #layer1.
	layer1 setProcessData: GeoPolylineProcessData new for: GeoPolyline.
	layer1 setProcessData: GeoPolygonProcessData new for: GeoPolygon.
	layer1 setProcessData: GeoCircleProcessData new for: GeoCircle.
]

{ #category : #initialization }
GeoViewBlocWorldOutlineForcedSample >> createGeographicSituation: aGeoViewManager [
	"create a Geographic situation and add it into the geographic view"
	| random |
	
	super createGeographicSituation: aGeoViewManager.
	geoCircles := OrderedCollection new.
	random := Random new.
	(1 to: 500) do:[ :i | | geoCircle longitude |
		geoCircle := GeoCircle new.	
		geoCircle key: (#circle, i printString) asSymbol.
		longitude := mercator 
			ifTrue: [ (random next * 360) - 180  ]
			ifFalse: [ (random next * 180) - 90 ].
		geoCircle absoluteCoordinates: (AbsoluteCoordinates 
			latitudeInDegrees: (random next * 180) - 90 
			longitudeInDegrees: longitude).
		geoCircle fillColor: Color random.
		geoCircle radiusInMeters: (random next * 200000).
		aGeoViewManager addGeoObject: geoCircle.	
		geoCircles add: geoCircle.
	]
]

{ #category : #running }
GeoViewBlocWorldOutlineForcedSample >> doGeoViewUpdate [
	| random |
	super doGeoViewUpdate.
	random := Random new.
	geoCircles do:[ :e |
		e absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: (random next * 180) - 90 longitudeInDegrees: (random next * 360) - 180).
		e fillColor: Color random.
		e radiusInMeters: (random next * 200000).
	].
	geoviewManager updateGeoObjects: geoCircles.
	
	^true
]
