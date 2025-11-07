Class {
	#name : #GeoBoundingBox,
	#superclass : #GeoShape,
	#traits : 'TGeoToolsBoundingBox',
	#classTraits : 'TGeoToolsBoundingBox classTrait',
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #accessing }
GeoBoundingBox >> absoluteCoordinates [

	| center |
	center := self centerAbsoluteCoordinates.
	^ center isValid ifTrue: [ center ] 
]

{ #category : #updating }
GeoBoundingBox >> updateWith: aGeoBoundingBox [

	super updateWith: aGeoBoundingBox.

	self topLatitudeInDegrees: aGeoBoundingBox topLatitudeInDegrees.
	self rightLongitudeInDegrees: aGeoBoundingBox rightLongitudeInDegrees.
	self bottomLatitudeInDegrees: aGeoBoundingBox bottomLatitudeInDegrees.
	self leftLongitudeInDegrees: aGeoBoundingBox leftLongitudeInDegrees.
]
