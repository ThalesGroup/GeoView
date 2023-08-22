Class {
	#name : #GeoViewBlocForcedSample,
	#superclass : #GeoViewBlocSample,
	#category : #'GeoView-Bloc-Examples'
}

{ #category : #defaults }
GeoViewBlocForcedSample class >> spaceSize [

	^ 1920 @ 1080
]

{ #category : #running }
GeoViewBlocForcedSample class >> start [
	<script: 'self start'>
	super start: self new.
]

{ #category : #defaults }
GeoViewBlocForcedSample class >> updateFrequency [
	^ 50 milliSeconds 
]

{ #category : #initialization }
GeoViewBlocForcedSample >> configureGeoViewManager: aGeoViewManager [
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

{ #category : #accessing }
GeoViewBlocForcedSample >> createGeographicSituation: aGeoViewManager [
	"create a Geographic situation and add it into the geographic view"
	| random france polygon shapeMap keys |
	
	"Basic World map ShapeFile : don t do that this is for the demo"
	shapeMap := ShapeMap fromBytes: self class worldOutlineShp.
	shapeMap shxBytes: self class worldOutlineShx.
	keys := 1.
	(ShapeFileReader fromShapeMap: shapeMap) do: [ :polygonsList | | list |
		list := (polygonsList select:[ :p | p key: (#poly, keys printString) asSymbol. p strokeColor: Color blue. keys := keys + 1. p absolutePositions size > 75]).
		aGeoViewManager addGeoObjects: list.
	].
	
	"France more detailed map"
	france := self class france collect: [ :points | 
		AbsoluteCoordinates 
			latitudeInDegrees: (points at: 2)
			longitudeInDegrees: (points at: 1) 
			altitudeInMeters: (points at: 3)].
	polygon := GeoPolygon new 
		key: #france1;
		absolutePositions: france;
		strokeWidth: 3;
		strokeColor: (Color white);
		fillColor: (Color fromString: '#80CDC1').
	aGeoViewManager addGeoObject: polygon.
	
	random := Random new.
	1 to: 100 do:[ :i | | geoRectangle |
		geoRectangle := GeoRectangle new.	
		geoRectangle key: i.
		geoRectangle absoluteCoordinates: (AbsoluteCoordinates latitudeInDegrees: (random next * 180) - 90 longitudeInDegrees: (random next * 360) - 180).
		geoRectangle fillColor: Color random.
		geoRectangle strokeColor: Color random.
		geoRectangle strokeWidth: 5.
		geoRectangle lengthInMeters1: (random next * 400 * 1000).
		geoRectangle lengthInMeters2: (random next * 400 * 1000).
		geoRectangle setProperty: #speedFactor value: random next. 
		aGeoViewManager addGeoObject: geoRectangle.	
		geoObjectList add: geoRectangle.
	].

	aGeoViewManager getView background: (Color fromString: '#92C5DE').
]

{ #category : #stimulator }
GeoViewBlocForcedSample >> doGeoViewUpdate [
	| random |
	random := Random new.
	geoObjectList do:[ :e | | newCoord |
		newCoord := e absoluteCoordinates copy.
		newCoord latitudeInDegrees: newCoord latitudeInDegrees + (0.1 * (e getProperty: #speedFactor)).
		newCoord longitudeInDegrees: newCoord longitudeInDegrees + (0.1 * (e getProperty: #speedFactor)).
				
		newCoord latitudeInDegrees >= 90 ifTrue:[newCoord latitudeInDegrees: -90].
		newCoord longitudeInDegrees >= 180 ifTrue:[newCoord longitudeInDegrees: -180].
		
		e absoluteCoordinates: newCoord.
	].
	geoviewManager updateGeoObjects: geoObjectList.
	
	^true
	
]
