Class {
	#name : #GeoViewBlocMercatorProjectionSample,
	#superclass : #GeoViewBlocSample,
	#category : #'GeoView-Bloc-Examples'
}

{ #category : #defaults }
GeoViewBlocMercatorProjectionSample class >> spaceSize [

	^ 1200 @ 800
]

{ #category : #running }
GeoViewBlocMercatorProjectionSample class >> start [
	<script: 'self start'>
	super start: self new.
]

{ #category : #initialization }
GeoViewBlocMercatorProjectionSample >> configureGeoViewManager: aGeoViewManager [
	"create a layer with GeoCircle processdata"

	| layer1 |
	super configureGeoViewManager: aGeoViewManager.

	layer1 := aGeoViewManager createAndAddGeoObjectLayer: #layer1.
	layer1 setProcessData: GeoPolylineProcessData new for: GeoPolyline.
	
	self setGeoViewManagerProjection: aGeoViewManager.
	
]

{ #category : #initialization }
GeoViewBlocMercatorProjectionSample >> createGeographicSituation: aGeoViewManager [
	"create a Geographic situation and add it into the geographic view"
	
	| grid polylines i |
	grid := Grid stepLat: 3 stepLon: 3 maxLat: 90 maxLon: 180.
	i := 1.
	polylines := grid meridians collect: [ :points | 
		i := i + 1.
		GeoPolyline new 
			key: i;
			absolutePositions: points;
			strokeWidth: 1;
			strokeColor: Color blue].
	aGeoViewManager addGeoObjects: polylines.
	geoObjectList addAll: polylines.
	
	polylines := grid parallels collect: [ :points | 
		i := i + 1.
		GeoPolyline new 
			key: i;
			absolutePositions: points;
			strokeWidth: 1;
			strokeColor: Color red].
	aGeoViewManager addGeoObjects: polylines.
	geoObjectList addAll: polylines.
	i := i + 1.
	polylines := GeoPolyline new
		key: i;
		absolutePositions: grid greenwich;
		strokeWidth: 3;
		strokeColor: Color blue.
	aGeoViewManager addGeoObject: polylines.
	geoObjectList add: polylines.
	i := i + 1.
	polylines := GeoPolyline new
		key: i;
		absolutePositions: grid equator;
		strokeWidth: 3;
		strokeColor: Color red.
	aGeoViewManager addGeoObject: polylines.
	geoObjectList add: polylines.
	
]

{ #category : #initialization }
GeoViewBlocMercatorProjectionSample >> setGeoViewManagerProjection: aGeoViewManager [
	"set the projection"
	
	aGeoViewManager getMapProjectionManagerServicesProvider setProjection: MercatorProjection new
	
]
