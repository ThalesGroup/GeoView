"
labordep: this class is POC, need to be refactored with standard processData and setup with isGeoProjectedShape: true/false parameter 
"
Class {
	#name : #GeoSegmentProjectedProcessData,
	#superclass : #GeoShapeProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #processing }
GeoSegmentProjectedProcessData >> findLastAndFirstPointsBetween: aStartAbsoluteCoordinates and: anEndAbsoluteCoordinates [
	| assoc |
	self flag:'labordep: POC to factorize'.
	
	"pour le refactoring : il faut passer la projection, les deux points et les algos de geodesics a utiliser (vincenty par defaut)"
	assoc := GeoViewProjectionUtils findSideBySideAbsoluteCoordinatesBetween: aStartAbsoluteCoordinates and: anEndAbsoluteCoordinates mapProjection: (self processor projection) geodesicFormulas: #VincentyFormulaClassToDoHere.
	
	^ assoc 
]

{ #category : #processing }
GeoSegmentProjectedProcessData >> processCreatedData: aKey incoming: aGeoSegment with: aDMultiPolylines context: aContext [

	| dMultiPolylines distance firstAzimuth from to n step points polylines previousStepGeo currentPoly |
	dMultiPolylines := aDMultiPolylines ifNil: [ SmockDMultiPolylines new ].
	super
		processCreatedData: aKey
		incoming: aGeoSegment
		with: dMultiPolylines
		context: aContext.

	"reset segment properties because usage of polyline"
	dMultiPolylines coordinates: nil.
	dMultiPolylines removePolylines.

	from := aGeoSegment fromAbsolutePosition.
	to := aGeoSegment toAbsolutePosition.
	distance := GeodesicUtils distanceInMetersFrom: from to: to.
	firstAzimuth := GeodesicUtils azimuthInRadiansFrom: from to: to.

	"echantillonage sur 100 points"
	n := 100.
	step := distance / n.
	polylines := OrderedCollection new.
	points := OrderedCollection new.
	currentPoly := SmockDPolyline new.
	polylines add: currentPoly.
	previousStepGeo := nil.
	(0 to: n) do: [ :i | | cartesianPoint stepGeo needNewPoly lastPoint firstPoint |
		needNewPoly := false.
		stepGeo := GeodesicUtils	absoluteCoordinatesAlongGeodesicFrom: from to: to atFraction: i asFloat / n.  
			
		"check if need to create a new polyline"
		previousStepGeo ifNotNil:[
			needNewPoly := self processor projection geodesicExitsValidDomainFrom: previousStepGeo to: stepGeo. 
		].
		
		needNewPoly ifTrue:[ | assoc |
			"calculer ici le point le plus proche de la projection, ajouter au polyline et commencer un nouveau avec le point le plus proche de lautre cote"
			
			"check if the points are inside projection limite because we cannot resolve the shape then"
			((self processor projection isAbsoluteCoordinatesOutsideProjectionLimit: previousStepGeo) and:[
				self processor projection isAbsoluteCoordinatesOutsideProjectionLimit: stepGeo]) ifFalse:[
			
				assoc := self findLastAndFirstPointsBetween: previousStepGeo and: stepGeo.
				lastPoint := assoc key.
				firstPoint := assoc value.
			
				cartesianPoint := 	self processor projection projLatLonToCart: lastPoint.
				currentPoly points add: cartesianPoint.
			
				"when first point is out of projection limit it seems than the shape cannot be displayed entirely"
				(self processor projection isAbsoluteCoordinatesOutsideProjectionLimit: firstPoint) ifFalse:[
					cartesianPoint := 	self processor projection projLatLonToCart: firstPoint.
					currentPoly := SmockDPolyline new.
					polylines add: currentPoly.
					currentPoly points add: cartesianPoint.
				].	
			
				previousStepGeo := firstPoint.
			].
			
		] ifFalse:[
			cartesianPoint := 	self processor projection projLatLonToCart: stepGeo.
			currentPoly points add: cartesianPoint.
			previousStepGeo := stepGeo.
		].
	].

	dMultiPolylines addPolylines: polylines.

	^ dMultiPolylines
]

{ #category : #processing }
GeoSegmentProjectedProcessData >> processUpdatedData: aKey incoming: aGeoSegment with: aDPolyline context: aContext [

	| dPolyline |
	dPolyline := aDPolyline.
	super processUpdatedData: aKey incoming: aGeoSegment with: dPolyline context: aContext.
	
	self flag:'labordep: todo'.

	^ dPolyline
]
