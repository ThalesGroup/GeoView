Class {
	#name : #GeoViewCommandApplicationTask,
	#superclass : #BlCommandApplicationTask,
	#category : #'GeoView-Core'
}

{ #category : #'api - running' }
GeoViewCommandApplicationTask >> run [

	commandQueue add: (BlEnqueuedCommand new
			 applier: element;
			 command: GeoViewGraphicModelLayerSortCommand new;
			 yourself).
	super run
]
