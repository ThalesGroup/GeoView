Class {
	#name : #GeoViewProjectionChanges,
	#superclass : #Object,
	#instVars : [
		'isMapProjectionChange',
		'isScaleChanged',
		'isExtentChanged',
		'isResolutionChanged',
		'isCenterChanged',
		'scaleCenterPoint'
	],
	#category : #'GeoView-Projections'
}

{ #category : #accessing }
GeoViewProjectionChanges >> isCenterChanged [

	^ isCenterChanged ifNil: [ isCenterChanged := false ]
]

{ #category : #accessing }
GeoViewProjectionChanges >> isCenterChanged: anObject [

	isCenterChanged := anObject
]

{ #category : #accessing }
GeoViewProjectionChanges >> isExtentChanged [

	^ isExtentChanged ifNil: [ isExtentChanged := false ]
]

{ #category : #accessing }
GeoViewProjectionChanges >> isExtentChanged: anObject [

	isExtentChanged := anObject
]

{ #category : #accessing }
GeoViewProjectionChanges >> isMapProjectionChange [

	^ isMapProjectionChange ifNil:[ isMapProjectionChange := false ]
]

{ #category : #accessing }
GeoViewProjectionChanges >> isMapProjectionChange: anObject [

	isMapProjectionChange := anObject
]

{ #category : #accessing }
GeoViewProjectionChanges >> isResolutionChanged [

	^ isResolutionChanged ifNil: [ isResolutionChanged := false ]
]

{ #category : #accessing }
GeoViewProjectionChanges >> isResolutionChanged: anObject [

	isResolutionChanged := anObject
]

{ #category : #accessing }
GeoViewProjectionChanges >> isScaleChanged [

	^ isScaleChanged ifNil: [ isScaleChanged := false ]
]

{ #category : #accessing }
GeoViewProjectionChanges >> isScaleChanged: anObject [

	isScaleChanged := anObject
]

{ #category : #accessing }
GeoViewProjectionChanges >> scaleCenterPoint [

	^scaleCenterPoint
]

{ #category : #accessing }
GeoViewProjectionChanges >> scaleCenterPoint: anObject [

anObject ifNil:[ Transcript show: 'scaleCenterPoint set a nil';cr.].
	scaleCenterPoint := anObject
]
