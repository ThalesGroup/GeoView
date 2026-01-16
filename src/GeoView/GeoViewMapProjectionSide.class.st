Class {
	#name : #GeoViewMapProjectionSide,
	#superclass : #Object,
	#category : #'GeoView-Projections'
}

{ #category : #UTM }
GeoViewMapProjectionSide class >> insideUTMZone [
	"When the side is inside an UTM zone"

	^ #insideUTMZone
]

{ #category : #UTM }
GeoViewMapProjectionSide class >> leftOfUTMZone [
	"When the side is not in the left of the UTM zone"

	^ #leftOfUTMZone
]

{ #category : #common }
GeoViewMapProjectionSide class >> leftOfZeroMeridian [
	"When the side is at the left of the zero meridian"

	^ #leftOfZeroMeridian
]

{ #category : #common }
GeoViewMapProjectionSide class >> outOfProjection [
	"When the side is out of projection"

	^ #outOfProjection
]

{ #category : #common }
GeoViewMapProjectionSide class >> outsideLatitudeLimitBottom [
	"When the side is out latitude bottom limit"

	^ #outsideLatitudeLimitBottom
]

{ #category : #common }
GeoViewMapProjectionSide class >> outsideLatitudeLimitTop [
	"When the side is out latitude top limit"

	^ #outsideLatitudeLimitTop
]

{ #category : #UTM }
GeoViewMapProjectionSide class >> rightOfUTMZone [
	"When the side is not in the right of the UTM zone"

	^ #rightOfUTMZone
]

{ #category : #common }
GeoViewMapProjectionSide class >> rightOfZeroMeridian [
	"When the side is at the right of the zero meridian"

	^ #rightOfZeroMeridian
]

{ #category : #UTM }
GeoViewMapProjectionSide class >> wrongUTMHemisphere [
	"When the side is not in the right hemisphere"

	^ #wrongUTMHemisphere
]

{ #category : #'see class side' }
GeoViewMapProjectionSide >> seeClassSide [ 
]
