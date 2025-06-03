Class {
	#name : #GeoViewAttributesDisplayFilter,
	#superclass : #GeoViewDisplayFilter,
	#category : #'GeoView-Core'
}

{ #category : #'instance creation' }
GeoViewAttributesDisplayFilter class >> allowedAttributes: anArray [

	^ self new allowedAttributes: anArray
]

{ #category : #accessing }
GeoViewAttributesDisplayFilter >> allowedAttributes [

	^ allowedAttributes
]

{ #category : #accessing }
GeoViewAttributesDisplayFilter >> allowedAttributes: anObject [

	allowedAttributes := anObject
]

{ #category : #testing }
GeoViewAttributesDisplayFilter >> isEmpty [

	^ self allowedAttributes isNil or: [ self allowedAttributes isEmpty ]
]
