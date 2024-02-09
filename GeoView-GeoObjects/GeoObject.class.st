"
I am the geographical object manipulate by a geo view model.
"
Class {
	#name : #GeoObject,
	#superclass : #Object,
	#traits : 'TSmockHaveProperties',
	#classTraits : 'TSmockHaveProperties classTrait',
	#instVars : [
		'key',
		'isVisible',
		'isSelectable',
		'absoluteCoordinates'
	],
	#category : #'GeoView-GeoObjects-GeoObjects'
}

{ #category : #accessing }
GeoObject >> absoluteCoordinates [
	^ absoluteCoordinates
]

{ #category : #accessing }
GeoObject >> absoluteCoordinates: anAbsoluteCoordinates [
	absoluteCoordinates := anAbsoluteCoordinates
]

{ #category : #copying }
GeoObject >> copy [
	| copy |
	copy := self class new.
	copy key: self key copy.		
	copy updateWith: self.
	^copy
]

{ #category : #accessing }
GeoObject >> isVisible [
	isVisible isNil ifTrue:[isVisible := true].
	^ isVisible
]

{ #category : #accessing }
GeoObject >> isVisible: aBoolean [
	isVisible := aBoolean
]

{ #category : #accessing }
GeoObject >> key [
	^ key
]

{ #category : #accessing }
GeoObject >> key: anObject [
	key := anObject
]

{ #category : #updating }
GeoObject >> updateWith: aGeoObject [

	self properties: aGeoObject properties copy.
	self absoluteCoordinates: aGeoObject absoluteCoordinates copy.
	self isVisible: aGeoObject isVisible.
]
