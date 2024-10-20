Class {
	#name : #GeoEllipseProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #processing }
GeoEllipseProcessData >> processCreatedData: aKey incoming: aGeoEllipse with: aDEllipse context: aContext [
	| dEllipse |
	dEllipse := aDEllipse ifNil:[SmockDEllipse new].
	super processCreatedData: aKey incoming: aGeoEllipse with: dEllipse context: aContext.
	
	dEllipse radius1: aGeoEllipse radiusInMeters1.
	dEllipse radius2: aGeoEllipse radiusInMeters2.
	^dEllipse
]

{ #category : #processing }
GeoEllipseProcessData >> processUpdatedData: aKey incoming: aGeoEllipse with: aDEllipse context: aContext [
	| dEllipse |
	dEllipse := aDEllipse.
	super processUpdatedData: aKey incoming: aGeoEllipse with: dEllipse context: aContext.
	
	dEllipse radius1: aGeoEllipse radiusInMeters1.
	dEllipse radius2: aGeoEllipse radiusInMeters2.	
	^dEllipse
]
