Class {
	#name : #GeoViewCommandApplicationStrategy,
	#superclass : #BlQueueBasedCommandApplicationStrategy,
	#category : #'GeoView-Core'
}

{ #category : #accessing }
GeoViewCommandApplicationStrategy >> newCommandApplicationTask [

	^ GeoViewCommandApplicationTask new
]
