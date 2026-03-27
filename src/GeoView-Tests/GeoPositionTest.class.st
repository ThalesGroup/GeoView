Class {
	#name : #GeoPositionTest,
	#superclass : #GeoObjectTest,
	#category : #'GeoView-Tests-GeoObjects'
}

{ #category : #accessing }
GeoPositionTest >> geoObjectClass [

	^ GeoPosition
]

{ #category : #tests }
GeoPositionTest >> testCopyGeoPositionWithImage [

	| geoPosition copy |
	geoPosition := self geoObject1.
	self assert: geoPosition image equals: nil.
	
	geoPosition image: (Form extent: 20 asPoint).
	self assert: (geoPosition image) notNil.
	copy := geoPosition copy.
	
	self assert: (copy image) notNil.
	self assert: geoPosition image width equals: 20.
	self assert: copy image width equals: 20.
	
	copy image setExtent: 40 asPoint depth: copy image depth.

	self assert: geoPosition image width equals: 20.
	self assert: copy image width equals: 40.
	
	geoPosition image: nil.
	self assert: geoPosition image equals: nil.
	self assert: (copy image) notNil.
]

{ #category : #tests }
GeoPositionTest >> testCopyGeoPositionWithText [

	| geoPosition copy |
	geoPosition := self geoObject1.
	self assert: geoPosition text equals: nil.
	
	geoPosition text: 'testText'.
	self assert: (geoPosition text) notNil.
	copy := geoPosition copy.
	
	self assert: (copy text) notNil.
	self assert: geoPosition text  equals: 'testText'.
	self assert: copy text equals: 'testText'.
	
	copy text: 'testTextCopy'.

	self assert: geoPosition text  equals: 'testText'.
	self assert: copy text equals: 'testTextCopy'.
	
	geoPosition text: nil.
	self assert: geoPosition text equals: nil.
	self assert: (copy text) notNil.
]
