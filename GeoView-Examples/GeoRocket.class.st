"
I am a rocket.
I am used for Geoplot Examples of rich object.
"
Class {
	#name : #GeoRocket,
	#superclass : #GeoObject,
	#instVars : [
		'kinematics',
		'name'
	],
	#category : #'GeoView-Examples'
}

{ #category : #accessing }
GeoRocket >> kinematics [
	^ kinematics
]

{ #category : #accessing }
GeoRocket >> kinematics: aKinematics [
	kinematics := aKinematics
]

{ #category : #accessing }
GeoRocket >> name [
	^ name
]

{ #category : #accessing }
GeoRocket >> name: anObject [
	name := anObject
]

{ #category : #updating }
GeoRocket >> updateWith: aGeoRocket [
	super updateWith: aGeoRocket.
	self name: aGeoRocket name copy.
	self kinematics: aGeoRocket kinematics copy.
]
