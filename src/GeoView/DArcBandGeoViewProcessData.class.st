Class {
	#name : #DArcBandGeoViewProcessData,
	#superclass : #DLeafShapeGeoViewProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #private }
DArcBandGeoViewProcessData >> createGShape2D [

	^ SmockGArcBand2D new
]

{ #category : #processing }
DArcBandGeoViewProcessData >> processUpdatedData: aKey incoming: aDArcBand with: aGArcBand2D context: aContext [

	| radiusMin radiusMax from to orientation aperture |
	super
		processUpdatedData: aKey
		incoming: aDArcBand
		with: aGArcBand2D
		context: aContext.
	aDArcBand radiusMin ifNil: [ ^ aGArcBand2D ].
	aDArcBand radiusMax ifNil: [ ^ aGArcBand2D ].
	aDArcBand orientation ifNil: [ ^ aGArcBand2D ].
	aDArcBand aperture ifNil: [ ^ aGArcBand2D ].

	aDArcBand isDrawModeDevice
		ifTrue: [ "draw as geometric angle"
				radiusMin := aDArcBand radiusMin.
				radiusMax := aDArcBand radiusMax.
				orientation := aDArcBand orientation.
				aperture := aDArcBand aperture ]
		ifFalse: [
				aDArcBand isDrawModeUser ifTrue: [ "draw as azimuth angle"
						radiusMin := aDArcBand radiusMin
						             * self processor projection metersByPixel.
						radiusMax := aDArcBand radiusMax
						             * self processor projection metersByPixel.
						orientation := aDArcBand orientation asTrigonometricAngle.
						aperture := aDArcBand aperture ] ].

	from := orientation - (aperture / 2).
	to := orientation + (aperture / 2).

	aGArcBand2D radiusMin: radiusMin.
	aGArcBand2D radiusMax: radiusMax.
	aGArcBand2D fromInDegrees: from.
	aGArcBand2D toInDegrees: to.

	^ aGArcBand2D
]
