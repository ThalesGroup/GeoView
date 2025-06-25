"
Subclass me to create your own business object processdata (Boat, Planes, Zones, etc.).
Using a class from this hierarchy is easier because there are a lot of utils.
"
Class {
	#name : #GeoViewDomainProcessData,
	#superclass : #SmockProcessData,
	#category : #'GeoView-Domain'
}

{ #category : #accessing }
GeoViewDomainProcessData class >> isAbstract [ 

	^ self == GeoViewDomainProcessData 
]
