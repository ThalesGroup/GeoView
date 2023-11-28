Class {
	#name : #GeoCircleProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-GeoObjects-ProcessData'
}

{ #category : #processing }
GeoCircleProcessData >> processCreatedData: aKey incoming: aGeoCircle with: aDCircle context: aContext [
	| dCircle |
	dCircle := aDCircle ifNil:[SmockDCircle new].
	super processCreatedData: aKey incoming: aGeoCircle with: dCircle context: aContext.
	
	dCircle radius: aGeoCircle radiusInMeters.
	^dCircle
]

{ #category : #processing }
GeoCircleProcessData >> processUpdatedData: aKey incoming: aGeoCircle with: aDCircle context: aContext [
	| dCircle |
	dCircle := aDCircle.
	super processUpdatedData: aKey incoming: aGeoCircle with: dCircle context: aContext.
	
	dCircle radius: aGeoCircle radiusInMeters.
	^dCircle
]
