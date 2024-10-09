Class {
	#name : #DSegmentGeoViewProcessData,
	#superclass : #DLeafShapeGeoViewProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #private }
DSegmentGeoViewProcessData >> createGShape2D [ 

	^ SmockGSSegment2D new
]

{ #category : #processing }
DSegmentGeoViewProcessData >> processUpdatedData: aKey incoming: aDSegment with: aGSegment2D context: aContext [

	| from to |
	super processUpdatedData: aKey incoming: aDSegment with: aGSegment2D context: aContext.
	(aDSegment coordinates isNil or:[ aDSegment coordinates2 isNil]) ifTrue:[ ^ aGSegment2D ].
	
	aDSegment isDrawModeDevice ifTrue:[ 
		from := aDSegment coordinates.
		to := aDSegment coordinates2.
	] ifFalse: [ 
		aDSegment isDrawModeUser ifTrue:[
			from := self processor projection projCartToPixel: aDSegment coordinates.
			to := self processor projection projCartToPixel: aDSegment coordinates2.
		].
	].

	aGSegment2D position: from.
	aGSegment2D extent: to.
	
	^ aGSegment2D 
]
