Class {
	#name : #ShapeFileReader,
	#superclass : #Object,
	#category : #'GeoView-Examples-Bloc'
}

{ #category : #'instance creation' }
ShapeFileReader class >> fromShapeMap: aShapeMap [
	
	aShapeMap hasPolygons ifTrue: [ ^ self fromShapeMapPolygons: aShapeMap ].
	aShapeMap hasLines ifTrue: [ ^ self fromShapeMapLines: aShapeMap ].
	aShapeMap hasPoints ifTrue: [ ^ self fromShapeMapPoints: aShapeMap ].
]

{ #category : #'instance creation' }
ShapeFileReader class >> fromShapeMapLines: aShapeMap [

	^ (1 to: aShapeMap numberOfShapes) collect: [ :i |
		(aShapeMap vertices2DByPartsForShapeIndex: i) collect: [ :part | | polyline | 
			polyline := GeoPolyline new.
			polyline absolutePositions: (part collect: 
				[ :point | AbsoluteCoordinates latitudeInDegrees: point y longitudeInDegrees: point x]).
			polyline strokeColor: aShapeMap arcColor.
			polyline strokeColor ifNotNil: [ polyline strokeWidth: 1 ].
			polyline]].
	
]

{ #category : #'instance creation' }
ShapeFileReader class >> fromShapeMapPoints: aShapeMap [

	self notYetImplemented
]

{ #category : #'instance creation' }
ShapeFileReader class >> fromShapeMapPolygons: aShapeMap [

	^ (1 to: aShapeMap numberOfShapes) collect: [ :i |
		(aShapeMap vertices2DByPartsForShapeIndex: i) collect: [ :part | | polygon | 
			polygon := GeoPolygon new.
			polygon absolutePositions: (part collect: 
				[ :point | AbsoluteCoordinates latitudeInDegrees: point y longitudeInDegrees: point x]).
			polygon fillColor: aShapeMap polygonColor.
			polygon strokeColor: aShapeMap arcColor.
			polygon strokeColor ifNotNil: [ polygon strokeWidth: 1 ].
			polygon]].
	
	
]
