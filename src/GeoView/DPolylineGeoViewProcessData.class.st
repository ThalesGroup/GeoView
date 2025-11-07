Class {
	#name : #DPolylineGeoViewProcessData,
	#superclass : #DLeafShapeGeoViewProcessData,
	#category : #'GeoView-ProcessDatas'
}

{ #category : #private }
DPolylineGeoViewProcessData >> createGShape2D [ 

	^ SmockGPolyline2D new
]

{ #category : #processing }
DPolylineGeoViewProcessData >> processUpdatedData: aKey incoming: aDPolyline with: aGPolyline2D context: aContext [

	| points |
	super processUpdatedData: aKey incoming: aDPolyline with: aGPolyline2D context: aContext.

	aDPolyline isDrawModeDevice
		ifTrue: [ points := aDPolyline points ]
		ifFalse: [
				aDPolyline isDrawModeUser ifTrue: [
						points := aDPolyline points collect: [ :pt |
							          self processor projection projCartToPixel: pt ] ] ].

	aGPolyline2D points: points.

	^ aGPolyline2D
]
