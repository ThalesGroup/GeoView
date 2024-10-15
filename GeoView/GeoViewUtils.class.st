Class {
	#name : #GeoViewUtils,
	#superclass : #Object,
	#category : #'GeoView-Core'
}

{ #category : #'layer creation' }
GeoViewUtils class >> createGeoObjectsLayer: aName [
	"Create a layer to display GeoObjects"

	| layer |
	layer := GeoViewGeoObjectsLayer new name: aName.

	layer setProcessData: GeoCircleProcessData new forClass: GeoCircle.
	layer setProcessData: GeoEllipseProcessData new forClass: GeoEllipse.
	layer setProcessData: GeoPolygonProcessData new forClass: GeoPolygon.
	layer setProcessData: GeoPolylineProcessData new forClass: GeoPolyline.
	layer setProcessData: GeoRectangleProcessData new forClass: GeoRectangle.
	layer setProcessData: GeoArcBandProcessData new forClass: GeoArcBand.
	layer setProcessData: GeoTextProcessData new forClass: GeoText.

	^ layer
]

{ #category : #'see class side' }
GeoViewUtils >> seeClassSide [ 
]
