Class {
	#name : #GeoViewCartoLayer,
	#superclass : #AbstractGeoViewBasicLayer,
	#instVars : [
		'cartoBackground',
		'mapMutex',
		'currentGraphicProjection',
		'previousCenter',
		'canvas',
		'tileBuilder',
		'formCanvas'
	],
	#category : #'GeoView-Layers'
}

{ #category : #drawing }
GeoViewCartoLayer >> aeDrawOn: aeCanvas [

	| cairoContext aeSurface filename fileref formTest|

	Transcript show: 'aeDrawOn';cr.
	filename := 'test.png'.
	formTest := self canvas asForm.
	formTest ifNil: [^self]. 
	formTest writePNGFileNamed: filename. 

	"surface writeToPng: 'test.png'."
	"formCanvas := self canvas host morph asForm.
	surface := AeCairoImageSurface fromForm: formCanvas."
	fileref := filename asFileReference.
	fileref isReadable ifFalse:[^self].
	aeSurface := AeCairoImageSurface newFromPngFileAt: fileref.
	"surface := self canvas morph surface."
	cairoContext := aeCanvas privateAeCairoContext.
	cairoContext sourceSurface: aeSurface x: 0 y: 0.
	cairoContext rectangle: (0 @ 0 extent: self canvas extent).

	cairoContext fill
]

{ #category : #accessing }
GeoViewCartoLayer >> canvas [

	canvas ifNil:[ self initBuilderAndCanvas].
	^canvas
]

{ #category : #accessing }
GeoViewCartoLayer >> cartoBackground [

	^cartoBackground
]

{ #category : #accessing }
GeoViewCartoLayer >> cartoBackground: anObject [

	^ cartoBackground := anObject
]

{ #category : #accessing }
GeoViewCartoLayer >> getCenterInLatLon [

	| center centerGeoPoint |
	center := self graphicProjection cartesianCenter.
	centerGeoPoint := self mapProjection projCartToLatLon: center.
	
	^centerGeoPoint latitudeInDegrees@centerGeoPoint longitudeInDegrees
]

{ #category : #private }
GeoViewCartoLayer >> initBuilderAndCanvas [
	
	tileBuilder := RSOSMBuilder new.
	tileBuilder build.
	canvas := tileBuilder canvas.
	canvas createMorph.
	canvas morph renderer: GeoViewCartoRenderer new.
	"canvas morph renderer callback:[ 150 milliSeconds wait. self sendRepaintRequest ]."
]

{ #category : #accessing }
GeoViewCartoLayer >> mapMutex [

	mapMutex ifNil: [ mapMutex := Monitor new ].
	^ mapMutex
]

{ #category : #accessing }
GeoViewCartoLayer >> tileBuilder [

	tileBuilder ifNil:[ self initBuilderAndCanvas].
	^tileBuilder
]

{ #category : #private }
GeoViewCartoLayer >> updateModel: aContext [

	| altitude factor scale|
	super updateModel: aContext.
	
	self graphicProjection ifNil: [ ^ self ].
	
	self tileBuilder latLong: self getCenterInLatLon.
	
	altitude := self graphicProjection altitudeInMeters.
	Transcript show: 'altitude:';show:altitude;cr.
	factor := altitude / RSOSMShape equatorLength.
	factor := factor / 15.
	Transcript show: 'factor:';show: factor;cr.
	scale := (1 / factor).
		Transcript show: 'scale:';show: scale;cr.
	self canvas camera scale: scale.
	"self canvas camera scale: 0.2."
	"canvas signalUpdate."
	self sendRepaintRequest.
	"self canvas camera self graphicProjection"

]
