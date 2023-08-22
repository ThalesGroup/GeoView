Class {
	#name : #GeoViewBlocRocketSample,
	#superclass : #GeoViewBlocSample,
	#instVars : [
		'geoRocket'
	],
	#category : #'GeoView-Bloc-Examples'
}

{ #category : #running }
GeoViewBlocRocketSample class >> start [
	<script: 'self start'>
	super start: self new.
]

{ #category : #initialization }
GeoViewBlocRocketSample >> configureGeoViewManager: aGeoViewManager [
	"create a layer with GeoRocket processdata"
	| layer1 |
	super configureGeoViewManager: aGeoViewManager.
	layer1 := aGeoViewManager createAndAddGeoObjectLayer: #layer1.
	layer1 setProcessData: GeoRocketProcessData new for: GeoRocket.
	
]

{ #category : #accessing }
GeoViewBlocRocketSample >> createGeographicSituation: aGeoViewManager [
	"create a Geographic situation and add it into the geographic view"
	
	geoRocket := GeoRocket new.	
	geoRocket key: 1.
	geoRocket absoluteCoordinates: AbsoluteCoordinates zero.
	aGeoViewManager addGeoObject: geoRocket.
]

{ #category : #stimulator }
GeoViewBlocRocketSample >> doGeoViewUpdate [
	| random |
	random := Random new.
	geoRocket absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: (random next * 90) longitudeInDegrees: (random next * 180)).
	geoviewManager updateGeoObject: geoRocket. 
	
	^true
]
