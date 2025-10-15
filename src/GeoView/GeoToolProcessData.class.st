Class {
	#name : #GeoToolProcessData,
	#superclass : #GeoObjectProcessData,
	#traits : 'TGeoProjectorProcessData',
	#classTraits : 'TGeoProjectorProcessData classTrait',
	#category : #'GeoView-Domain - GeoObjects'
}

{ #category : #accessing }
GeoToolProcessData class >> isAbstract [ 

	^ self == GeoToolProcessData 
]
