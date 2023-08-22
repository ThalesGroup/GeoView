Class {
	#name : #GeoViewBlocWorldOutlineSample,
	#superclass : #GeoViewBlocSample,
	#instVars : [
		'grid',
		'mercator'
	],
	#category : #'GeoView-Bloc-Examples'
}

{ #category : #running }
GeoViewBlocWorldOutlineSample class >> mercator [
	<script: 'self mercator'>
	super start: (self basicNew mercator; initialize).
]

{ #category : #defaults }
GeoViewBlocWorldOutlineSample class >> spaceSize [

	^ 1200 @ 800
]

{ #category : #running }
GeoViewBlocWorldOutlineSample class >> transverseMercator [
	<script: 'self transverseMercator'>
	super start: (self basicNew transverseMercator; initialize).
]

{ #category : #initialization }
GeoViewBlocWorldOutlineSample >> configureGeoViewManager: aGeoViewManager [
	"create a layer with GeoCircle processdata"

	| layer1 |
	super configureGeoViewManager: aGeoViewManager.
	"create a GeoCircle and add it into the geographic view"
	layer1 := aGeoViewManager createAndAddGeoObjectLayer: #layer1.
	layer1 setProcessData: GeoPolylineProcessData new for: GeoPolyline.
	layer1 setProcessData: GeoPolygonProcessData new for: GeoPolygon.
	
]

{ #category : #initialization }
GeoViewBlocWorldOutlineSample >> createGeographicSituation: aGeoViewManager [
	"create a Geographic situation and add it into the geographic view"
	
	| polylines shapeMap keys france polygon aGeoplotManager |
	keys := 0.
	"polylines := self grid meridians collect: [ :points |
		keys := keys + 1. 
		GeoPolyline new 
			key: (#poly, keys printString) asSymbol;
			absolutePositions: points;
			strokeWidth: 1;
			strokeColor: Color lightGray]."
	"aGeoViewManager addGeoObjects: polylines.
	geoObjectList addAll: polylines."
	
	"polylines := self grid parallels collect: [ :points | 
		keys := keys + 1.
		GeoPolyline new 
			key: (#poly, keys printString) asSymbol;
			absolutePositions: points;
			strokeWidth: 1;
			strokeColor: Color lightGray]."
	"aGeoViewManager addGeoObjects: polylines.
	geoObjectList addAll: polylines."
	
	polylines := GeoPolyline new
		key: (#poly, keys printString) asSymbol;
		absolutePositions: grid greenwich;
		strokeWidth: 3;
		strokeColor: Color blue.
	keys := keys + 1.
	"aGeoViewManager addGeoObject: polylines.
	geoObjectList add: polylines."
	
	polylines := GeoPolyline new
		key: (#poly, keys printString) asSymbol;
		absolutePositions: grid equator;
		strokeWidth: 3;
		strokeColor: Color red.
	keys := keys + 1.
	"aGeoViewManager addGeoObject: polylines.
	geoObjectList add: polylines."
	
	shapeMap := ShapeMap fromBytes: self class worldOutlineShp.
	shapeMap shxBytes: self class worldOutlineShx.
	(ShapeFileReader fromShapeMap: shapeMap) do: [ :polygonsList | 
		polygonsList do:[ :p | p key: (#poly, keys printString) asSymbol. keys := keys + 1. ].
		aGeoViewManager addGeoObjects: polygonsList.
		geoObjectList addAll: polygonsList ].
	
	"World with polygons cut"
	"(ShapeFileReader fromShapeMap: 
		(ShapeMap fromFile: self class shapefile)) do: [ :polygons | | cutPolygons |
			polygons isArray 
				ifTrue: 
					[ polygons do: [ :polygon | 
						cutPolygons := self cutPolygonsPoints: polygon.
						aGeoplotManager addGeoObjects: cutPolygons.
						geoObjectList addAll: cutPolygons ]]
				ifFalse: 
					[ cutPolygons := self cutPolygonsPoints: polygons.
					aGeoplotManager addGeoObjects: cutPolygons.
					geoObjectList addAll: cutPolygons ]]"
			
	"france := GeoPolygon new.
	france strokeColor: Color black.
	france strokeWidth: 1.
	france absolutePositions: { 
		AbsoluteCoordinates latitudeInDegree: 30 longitudeInDegree: 160.
		AbsoluteCoordinates latitudeInDegree: 30 longitudeInDegree: -170.
		AbsoluteCoordinates latitudeInDegree: 15 longitudeInDegree: -170.
		AbsoluteCoordinates latitudeInDegree: 0 longitudeInDegree: 170.
		AbsoluteCoordinates latitudeInDegree: -30 longitudeInDegree: -170.
		AbsoluteCoordinates latitudeInDegree: -30 longitudeInDegree: 160. }."
	"cuttedPolygons := Array with: france."
	"cuttedPolygons := self cutPolygonsPoints: france.
	aGeoplotManager addGeoObjects: cuttedPolygons.
	geoObjectList addAll: cuttedPolygons."
	
	"Simplified France outline"
	france := self class france collect: [ :points | 
		AbsoluteCoordinates 
			latitudeInDegrees: (points at: 2)
			longitudeInDegrees: (points at: 1) 
			altitudeInMeters: (points at: 3)].
	polygon := GeoPolygon new 
		absolutePositions: france;
		strokeWidth: 1;
		fillColor: Color lightBlue;
		strokeColor: Color blue.
	aGeoViewManager addGeoObject: polygon.
	geoObjectList add: polygon.
	

]

{ #category : #'cut polygons' }
GeoViewBlocWorldOutlineSample >> cutPolygonsPoints: polygon [
"algo fait uniquement pour cet example"
"ne fonctionne que pour un centre de projection 0'0"

	mercator 
		ifTrue: [ ^ self cutPolygonsPointsMercator: polygon ]
		ifFalse: [ ^ self cutPolygonsPointsUTM: polygon ]
	
]

{ #category : #'cut polygons' }
GeoViewBlocWorldOutlineSample >> cutPolygonsPointsMercator: polygon [
"algo fait uniquement pour cet example"
"ne fonctionne que pour un centre de projection 0'0"

	| newPolygonsList points rejectedPoints |
	newPolygonsList := OrderedCollection new.
	points := polygon absolutePositions.
	rejectedPoints := OrderedCollection new.
	2 to: points size do: [:i | | point previousPoint |
		point := points at: i.
		previousPoint := points at: i - 1.
		(point longitudeInDegrees - previousPoint longitudeInDegrees) abs > 180
			ifTrue: [ | polygonEnded j newPolygon newPoints |
				polygonEnded := false.
				previousPoint := point.
				j := i.
				[ polygonEnded  ] whileFalse: 
				 [ j := j + 1.
					point := points at: j.
					(point longitudeInDegrees - previousPoint longitudeInDegrees) abs > 180 ifTrue: 
						[ polygonEnded := true ]].
				newPolygon := polygon copy.
				newPoints := points copyFrom: i to: j.
				newPolygon absolutePositions: newPoints.
				newPolygonsList add: newPolygon.
				rejectedPoints addAll: newPoints].
		polygon absolutePositions: (points reject: [ :p | rejectedPoints includes: p]).
		newPolygonsList add: polygon].
		
		^ newPolygonsList 
	
]

{ #category : #'cut polygons' }
GeoViewBlocWorldOutlineSample >> cutPolygonsPointsUTM: polygonsList [
"algo fait uniquement pour cet example"
"ne fonctionne que pour un centre de projection 0'0"

	| longMin longMax newPolygonsList |
	longMin := grid maxLon negated.
	longMax := grid maxLon.
	newPolygonsList := OrderedCollection new.
	
	polygonsList do: [ :polygon | | points newPolygons |
		points := polygon absolutePositions.
		newPolygons := OrderedCollection new.
		points do: [ :point |
			point longitudeInDegrees > longMax ifTrue: [  ] ] ]
	
]

{ #category : #accessing }
GeoViewBlocWorldOutlineSample >> grid [
	^ grid
]

{ #category : #accessing }
GeoViewBlocWorldOutlineSample >> grid: anObject [
	grid := anObject
]

{ #category : #initialization }
GeoViewBlocWorldOutlineSample >> mercator [
	
	mercator := true.
	self grid: (Grid stepLat: 5 stepLon: 5 maxLat: 90 maxLon: 180).
]

{ #category : #initialization }
GeoViewBlocWorldOutlineSample >> transverseMercator [
	
	mercator := false.
	self grid: (Grid stepLat: 5 stepLon: 5 maxLat: 90 maxLon: 90).
]
