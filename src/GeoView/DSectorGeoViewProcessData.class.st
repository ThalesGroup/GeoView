Class {
	#name : #DSectorGeoViewProcessData,
	#superclass : #DLeafShapeGeoViewProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #private }
DSectorGeoViewProcessData >> createGShape2D [

	^ SmockGSector2D new
]

{ #category : #processing }
DSectorGeoViewProcessData >> processUpdatedData: aKey incoming: aDSector with: aGSector2D context: aContext [

	| radius from to orientation aperture |
	super processUpdatedData: aKey incoming: aDSector with: aGSector2D context: aContext.
	aDSector radius ifNil:[ ^ aGSector2D ].
	aDSector orientation ifNil:[ ^ aGSector2D ].
	aDSector aperture ifNil:[ ^ aGSector2D ].
		
	aDSector isDrawModeDevice ifTrue:[ 
		"draw as geometric angle"
		radius := aDSector radius.
		orientation := aDSector orientation.
		aperture := aDSector aperture.
	] ifFalse: [ 
		aDSector isDrawModeUser ifTrue:[
			"draw as azimuth angle"
			radius := aDSector radius * self processor projection metersByPixel.
			orientation := aDSector orientation asTrigonometricAngle.
			aperture := aDSector aperture.
		].
	].

	from := orientation - (aperture / 2).
	to := orientation + (aperture / 2).

	aGSector2D radius: radius.
	aGSector2D fromInDegrees: from.
	aGSector2D toInDegrees: to.
	
	^ aGSector2D 
]
