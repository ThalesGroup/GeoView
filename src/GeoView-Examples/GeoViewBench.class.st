"
I am a bench class to test performances
"
Class {
	#name : #GeoViewBench,
	#superclass : #Object,
	#category : #'GeoView-Examples'
}

{ #category : #projections }
GeoViewBench class >> timeToProjectCoordinates [
	"Transform coordinates is several projections and return the result is an array"

	<script>
	| absoluteCoordinatesList projections results |
	absoluteCoordinatesList := (1 to: 1000000) collect: [ :i |
		                           AbsoluteCoordinates random ].
	projections := {
		               GeoViewMercatorProjection new.
		               GeoViewWebMercatorProjection new.
		               GeoViewUTMProjection new }.
	results := Dictionary new.

	"project"
	projections do: [ :proj |
			| time cartesianCoordinatesList |
			cartesianCoordinatesList := OrderedCollection new.
			"first => projection from lat lon to cart"
			time := [
				        cartesianCoordinatesList :=
					        (absoluteCoordinatesList collect: [ :coord |
						         proj projLatLonToCart: coord ]) ] timeToRunWithoutGC.
			"second => projection from cart to lat lon"
			time := time + [
			        cartesianCoordinatesList do: [ :coord |
				       coord ifNotNil:[ proj projCartToLatLon: coord ] ] ] timeToRunWithoutGC.
			results at: proj printString put: time ].

	"show result"
	results inspect
]

{ #category : #'see class side' }
GeoViewBench >> seeClassSide [ 
]
