"
An FTP Server.
"
Class {
	#name : #FTPServer,
	#superclass : #Object,
	#instVars : [
		'settings',
		'listener',
		'sessions',
		'process'
	],
	#classVars : [
		'Servers'
	],
	#category : #'FTP-Server'
}

{ #category : #private }
FTPServer class >> addServer: aServer [
	self servers add: aServer.
]

{ #category : #initialization }
FTPServer class >> initialize [
	Smalltalk addToStartUpList: self.
	Smalltalk addToShutDownList: self.
]

{ #category : #'instance-creation' }
FTPServer class >> on: anInteger [
	^ self on: anInteger context: FTPDispatcher new.
]

{ #category : #'instance-creation' }
FTPServer class >> on: anInteger context: aContext [
	| server |
	server := self new.
	server settings
		port: anInteger;
		context: aContext.
	^ server.
]

{ #category : #private }
FTPServer class >> removeServer: aServer [
	self servers remove: aServer.
]

{ #category : #accessing }
FTPServer class >> servers [
	^ Servers ifNil: [ Servers := Set new ].
]

{ #category : #initialization }
FTPServer class >> shutDown [
	self servers do: [ :each | each shutDown ].
]

{ #category : #'instance creation' }
FTPServer class >> start [
	^ self new  
		start;
		yourself.
]

{ #category : #'instance-creation' }
FTPServer class >> startOn: aNumber [
	^ (self on: aNumber) start.
]

{ #category : #'instance-creation' }
FTPServer class >> startOn: aNumber context: aContext [
	^ (self on: aNumber context: aContext) start.
]

{ #category : #initialization }
FTPServer class >> startUp [
	Socket initializeNetwork.
]

{ #category : #'instance-creation' }
FTPServer class >> stopAll [
	self servers do: [:ea | ea stop]
]

{ #category : #'private-starting' }
FTPServer >> createListener [
	listener := Socket newTCP.
	listener 
		listenOn: self settings port 
		backlogSize: self settings backlog.
]

{ #category : #'private-starting' }
FTPServer >> createProcess [
	process := Process 
		forContext: [
			[ self serverLoop ]
				ensure: [ self destroyServer ] ]
		priority: self settings priority.
]

{ #category : #'private-starting' }
FTPServer >> createServer [
	self createSessions.
	self createProcess.
	self createListener.
	
]

{ #category : #'private-starting' }
FTPServer >> createSession: aSocket [
	self sessions add: (FTPSession new
		setContext: self settings context copy;
		setSocket: aSocket;
		setServer: self;
		run).
]

{ #category : #'private-starting' }
FTPServer >> createSessions [
	sessions := Set new.
]

{ #category : #'private-stopping' }
FTPServer >> destroyListener [
	listener destroy.
	listener := nil.
]

{ #category : #'private-stopping' }
FTPServer >> destroyProcess [
	process := nil.
]

{ #category : #'private-stopping' }
FTPServer >> destroyServer [
	self destroyProcess.
	self destroyListener.
	self destroySessions.
]

{ #category : #'private-stopping' }
FTPServer >> destroySession: aSession [
	self sessions remove: aSession.
]

{ #category : #'private-stopping' }
FTPServer >> destroySessions [
	self sessions do: [ :each | each close ].
	sessions := nil.
]

{ #category : #initialization }
FTPServer >> initialize [
	super initialize.
	settings := FTPSettings new.
	sessions := Set new.
]

{ #category : #testing }
FTPServer >> isConnected [
	^ self listener notNil.
]

{ #category : #testing }
FTPServer >> isRunning [
	^ self process notNil.
]

{ #category : #accessing }
FTPServer >> listener [
	^ listener
]

{ #category : #printing }
FTPServer >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' port: '; print: self settings port.
]

{ #category : #accessing }
FTPServer >> process [
	^ process
]

{ #category : #actions }
FTPServer >> restart [
	self stop; start.
]

{ #category : #private }
FTPServer >> serverLoop [
	[ self serverLoopBody ] repeat.
]

{ #category : #private }
FTPServer >> serverLoopBody [
	| socket |
	self isConnected
		ifFalse: [ self destroyListener; createListener ].
	socket := listener 
		waitForAcceptFor: self settings timeout 
		ifTimedOut: [ nil ].
	socket notNil ifTrue: [
		socket isConnected
			ifTrue: [ self createSession: socket ]
			ifFalse: [ socket destroy ] ].
	
]

{ #category : #accessing }
FTPServer >> servers [
	^ self class servers.
]

{ #category : #accessing }
FTPServer >> sessions [
	^ sessions
]

{ #category : #accessing }
FTPServer >> settings [
	^ settings
]

{ #category : #private }
FTPServer >> shutDown [
	self sessions copy 
		do: [ :each | each close ].
]

{ #category : #actions }
FTPServer >> start [
	self isConnected ifTrue: [ ^ self ].
	self startServer.
]

{ #category : #private }
FTPServer >> startServer [
	listener := FTPServerListener server: self.
	listener start.
	self servers add: self.
]

{ #category : #private }
FTPServer >> startSession: aSocket [
	self sessions add: (FTPSession new
		setAuthenticator: self settings authenticator;
		setContext: self settings context;
		setSocket: aSocket;
		setServer: self;
		run).
]

{ #category : #actions }
FTPServer >> stop [
	self isConnected ifFalse: [ ^ self ].
	self stopServer; shutDown.
]

{ #category : #private }
FTPServer >> stopServer [
	listener stop.
	listener := nil.
	self servers remove: self.
]

{ #category : #private }
FTPServer >> stopSession: aSession [
	self sessions remove: aSession ifAbsent: nil.
]
