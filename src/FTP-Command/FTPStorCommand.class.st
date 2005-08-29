"
A STOR request asks the server to read the contents of a file from the data connection already established by the client. The STOR parameter is an encoded pathname of the file. The file is either a binary file or a text file, depending on the most recent TYPE request. If the server is willing to create a new file under that name, or replace an existing file under that name, it responds with a mark using code 150. It then stops accepting new connections, attempts to read the contents of the file from the data connection, and closes the data connection. Finally it

- accepts the STOR request with code 226 if the entire file was successfully received and stored;
- rejects the STOR request with code 425 if no TCP connection was established;
- rejects the STOR request with code 426 if the TCP connection was established but then broken by the client or by network failure; or
- rejects the STOR request with code 451, 452, or 552 if the server had trouble saving the file to disk.

The server may reject the STOR request (code 450, 452, or 553) without first responding with a mark. In this case the server does not touch the data connection.
"
Class {
	#name : #FTPStorCommand,
	#superclass : #FTPFileCommand,
	#category : 'FTP-Command-Transfer'
}

{ #category : #accessing }
FTPStorCommand class >> command [
	^ 'STOR'
]

{ #category : #processing }
FTPStorCommand >> execute [
	self checkTarget: #isFile.
	(FTPResponse code: 150)
		writeOn: self connection stream.
	self session withStreamDo: [ :stream |
		target contents: stream upToEnd ].
	self return: (FTPResponse code: 226).
]