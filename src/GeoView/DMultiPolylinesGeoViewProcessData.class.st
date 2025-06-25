Class {
	#name : #DMultiPolylinesGeoViewProcessData,
	#superclass : #DMultiShapesGeoViewProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #private }
DMultiPolylinesGeoViewProcessData >> createGShape2D [

	^ SmockGMultiPolylines2D new
]

{ #category : #processing }
DMultiPolylinesGeoViewProcessData >> processUpdatedData: aKey incoming: aDMultiPolylines with: aGMultiPolylines2D context: aContext [

	super processUpdatedData: aKey incoming: aDMultiPolylines with: aGMultiPolylines2D context: aContext.
	
	aGMultiPolylines2D removePolylines.	
	(aDMultiPolylines polylines isEmpty) ifTrue:[ ^ aGMultiPolylines2D ].

	aDMultiPolylines polylines do:[ :dPolyline | | gPolyline2D points |
		aDMultiPolylines isDrawModeDevice ifTrue:[ 
			points := dPolyline points
		] ifFalse: [ 
			aDMultiPolylines isDrawModeUser ifTrue:[
				points := dPolyline points collect:[:pt |
					self processor projection projCartToPixel: pt
				].
			].
		].
		gPolyline2D := SmockGPolyline2D new.
		gPolyline2D points: points.
		aGMultiPolylines2D addPolyline: gPolyline2D.
	].
	
	^ aGMultiPolylines2D 
]
