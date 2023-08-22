Class {
	#name : #GeoViewBlocUTMProjectionSample,
	#superclass : #GeoViewBlocMercatorProjectionSample,
	#category : #'GeoView-Bloc-Examples'
}

{ #category : #defaults }
GeoViewBlocUTMProjectionSample class >> spaceSize [

	^ 1200 @ 800
]

{ #category : #running }
GeoViewBlocUTMProjectionSample class >> start [
	<script: 'self start'>
	super start: self new.
]

{ #category : #initialization }
GeoViewBlocUTMProjectionSample >> createGeographicSituation: aGeoViewManager [
	"create a Geographic situation and add it into the geographic view"
	
	| grid polylines i |
	grid := Grid stepLat: 1.5 stepLon: 1.5 maxLat: 90 maxLon: 90.
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
GeoViewBlocUTMProjectionSample >> setGeoViewManagerProjection: aGeoViewManager [

	aGeoViewManager getMapProjectionManagerServicesProvider setProjection: UTMProjection new
]
