"
Subclass me to create your own business object processdata (Boat, Planes, Zones, etc.).
Using a class from this hierarchy is easier because there are a lot of utils.
"
Class {
	#name : #GeoBusinessObjectProcessData,
	#superclass : #SmockProcessData,
	#category : #'GeoView-Business'
}

{ #category : #accessing }
GeoBusinessObjectProcessData class >> isAbstract [ 

	^ self == GeoBusinessObjectProcessData 
]
