"
This trait have common behavior for Business Objects process data which need to be represented by projected shapes.
Use it to use utils to have tools to easily project your Business object into DShapes.
"
Trait {
	#name : #TGeoProjectorProcessData,
	#instVars : [
		'projectionQuality',
		'geodesicFormulas'
	],
	#category : #'GeoView-Projections'
}

{ #category : #utilities }
TGeoProjectorProcessData >> createCartesianPolylinesFrom: aFromAbsolutePosition to: aToAbsolutePosition [
	"Create Cartesian Polylines (using DPolylines) for a geodesic trajectory from a start point to an end point. Each polylines corresponding to a projection cut (not necessary)"
	
	| from to distance firstAzimuth n step polylines points currentPoly previousStepGeo |
	from := aFromAbsolutePosition.
	to := aToAbsolutePosition.
	
	distance := self geodesicFormulas distanceInMetersFrom: from to: to.
	firstAzimuth := self geodesicFormulas azimuthInRadiansFrom: from to: to.
	
	n := self geodesicSamplingForDistanceInMeters: distance.
	step := distance / n.
	polylines := OrderedCollection new.
	points := OrderedCollection new.
	currentPoly := SmockDPolyline new.
	polylines add: currentPoly.
	previousStepGeo := nil.
	
	(0 to: n) do: [ :i | | cartesianPoint stepGeo needNewPoly lastPoint firstPoint |
		needNewPoly := false.
		stepGeo := self geodesicFormulas absoluteCoordinatesAlongGeodesicFrom: from to: to atFraction: i asFloat / n.  
			
		"check if need to create a new polyline"
		previousStepGeo ifNotNil:[
			needNewPoly := self processor projection geodesicExitsValidDomainFrom: previousStepGeo to: stepGeo. 
		].
		
		needNewPoly ifTrue:[ | assoc |
			"calculer ici le point le plus proche de la projection, ajouter au polyline et commencer un nouveau avec le point le plus proche de lautre cote"
			
			"check if the points are inside projection limite because we cannot resolve the shape then"
			((self processor projection isAbsoluteCoordinatesOutsideProjectionLimit: previousStepGeo) and:[
				self processor projection isAbsoluteCoordinatesOutsideProjectionLimit: stepGeo]) ifFalse:[
			
				assoc := self findLastAndFirstPointsOnProjectionExitBetween: previousStepGeo and: stepGeo.
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

	^polylines 
]

{ #category : #utilities }
TGeoProjectorProcessData >> findLastAndFirstPointsOnProjectionExitBetween: aStartAbsoluteCoordinates and: anEndAbsoluteCoordinates [
	"Find the last and the first point when a geodesic is cutting by a projection exit. 
	Be carefull to check that the geodesic is effectively cut by a projection border! 
	Use self processor projection isAbsoluteCoordinatesOutsideProjectionLimit: a[Start|End]AbsoluteCoordinates to do that"

	| assoc |
	assoc := GeoViewProjectionUtils
		         findSideBySideAbsoluteCoordinatesBetween:
		         aStartAbsoluteCoordinates
		         and: anEndAbsoluteCoordinates
		         mapProjection: self processor projection
		         geodesicFormulas: self geodesicFormulas.

	^ assoc
]

{ #category : #accessing }
TGeoProjectorProcessData >> geodesicFormulas [

	^ geodesicFormulas ifNil: [
		  self usingVincentyFormulas.
		  geodesicFormulas ]
]

{ #category : #accessing }
TGeoProjectorProcessData >> geodesicFormulas: aGeodesicFormulas [

	geodesicFormulas := aGeodesicFormulas
]

{ #category : #utilities }
TGeoProjectorProcessData >> geodesicSamplingForDistanceInMeters: aDistanceInM [

	self flag:'considere projection quality here with a sampling calculation algorithm'.

	^ 100
]

{ #category : #projector }
TGeoProjectorProcessData >> highProjectionQuality [

	self projectionQuality: #high
]

{ #category : #projector }
TGeoProjectorProcessData >> lowProjectionQuality [

	self projectionQuality: #low
]

{ #category : #projector }
TGeoProjectorProcessData >> mediumProjectionQuality [

	self projectionQuality: #medium
]

{ #category : #accessing }
TGeoProjectorProcessData >> projectionQuality [

	^ projectionQuality ifNil: [
		  self highProjectionQuality.
		  projectionQuality ]
]

{ #category : #accessing }
TGeoProjectorProcessData >> projectionQuality: aSymbol [
]

{ #category : #projector }
TGeoProjectorProcessData >> ultraProjectionQuality [

	self projectionQuality: #ultra
]

{ #category : #projector }
TGeoProjectorProcessData >> usingVincentyFormulas [

	self geodesicFormulas: GeodesicVincentyFormulas new
]
