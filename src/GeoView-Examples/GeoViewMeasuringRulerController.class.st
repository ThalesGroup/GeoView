Class {
	#name : #GeoViewMeasuringRulerController,
	#superclass : #BlEventListener,
	#instVars : [
		'geoView',
		'measuringRuler',
		'isMeasuring'
	],
	#category : #'GeoView-Examples-Utils'
}

{ #category : #'mouse handlers' }
GeoViewMeasuringRulerController >> clickEvent: anEvent [

	self isMeasuring: false
	
	
]

{ #category : #'mouse handlers' }
GeoViewMeasuringRulerController >> doubleClickEvent: anEvent [

	| coordinates |

	"remove previous measure"
	measuringRuler ifNotNil: [
			geoView removeObject: measuringRuler.
			measuringRuler := nil ].

	coordinates := geoView absoluteCoordinatesFromGlobalPoint: anEvent position.
	coordinates ifNil: [ ^ self ].

	"start a measure"
	self isMeasuring: true.
	measuringRuler := GeoMeasuringRuler key: #measuringRuler.
	measuringRuler fromAbsoluteCoordinates: coordinates.
	geoView addObject: measuringRuler
]

{ #category : #accessing }
GeoViewMeasuringRulerController >> isMeasuring [

	^ isMeasuring ifNil: [ isMeasuring := false ]
]

{ #category : #accessing }
GeoViewMeasuringRulerController >> isMeasuring: aBoolean [

	isMeasuring := aBoolean
]

{ #category : #'mouse handlers' }
GeoViewMeasuringRulerController >> mouseMoveEvent: anEvent [

	| coordinates |
	self isMeasuring ifFalse:[ ^ self ].
	
	coordinates := geoView absoluteCoordinatesFromGlobalPoint: anEvent position.
	coordinates ifNil:[ ^ self ].
	
	measuringRuler toAbsoluteCoordinates: coordinates.
	geoView updateObject: measuringRuler.
]

{ #category : #'api - hooks' }
GeoViewMeasuringRulerController >> onInstalledIn: aGeoView [

	super onInstalledIn: aGeoView.
	geoView := aGeoView
]

{ #category : #'api - hooks' }
GeoViewMeasuringRulerController >> onUninstalledIn: aGeoView [

	measuringRuler ifNotNil: [ geoView removeObject: measuringRuler ].
	measuringRuler := nil.
	geoView := nil.

	super onUninstalledIn: aGeoView
]
