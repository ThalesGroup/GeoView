Class {
	#name : #GeoViewProjectionChanges,
	#superclass : #GeoViewUpdateContext,
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

{ #category : #testing }
GeoViewProjectionChanges >> isProjectionChanges [

	^ true
]

{ #category : #accessing }
GeoViewProjectionChanges >> isResolutionChanged [

	self 
		deprecated:'This is a scale changed' 
		transformWith: '`@receiver isResolutionChanged' -> '`@receiver isScaleChanged'.
		
	^ isResolutionChanged ifNil: [ isResolutionChanged := false ]
]

{ #category : #accessing }
GeoViewProjectionChanges >> isResolutionChanged: anObject [

	self 
		deprecated:'This is a scale changed' 
		transformWith: '`@receiver isResolutionChanged: `@anObject' -> '`@receiver isScaleChanged: `@anObject'.
		
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
