# pharo-couchdb
This provides a basic Pharo client for [CouchDB NoSQL Document Database](https://couchdb.org) with support for basic JSON documents as well objects serialization/deserialization in JSON format.

The source is based on an [old version](https://cwiki.apache.org/confluence/display/COUCHDB/Smalltalk) for VisualWorks, but this one uses [Zinc](https://github.com/svenvc/Zinc) HTTP client (`ZnClient`), URL objects (`ZnUrl`) instead of plain URL strings, has the `Couch` prefix for the class names (due to the lack of namespaces), and has other refactorings that I considered relevant (although there are many more to do).

This version also supports document attachment operations using Base64 encoding for download.

![CouchDB](couchdb-vertical-logo.png)

# Client Installation
```smalltalk
Metacello new
	baseline: 'CouchDB';
	repository: 'github://eMaringolo/pharo-couchdb/src';
	load.
```

# Server Installation
Download CouchDB and install it [following the instructions in CouchDB website](https://couchdb.apache.org/#download). 

If you install it using defaults, it will a create a default server running at `http://127.0.0.1:5984/` without authentication. All the exapmles will assume the server is running at that address and port.


# How to use

The current version provides the class `CouchInterface` that will provide control over the server databases.

You can instantiate an interface by evaluating:

```smalltalk
client := CouchInterface url: 'http://127.0.0.1:5984/'.
```

But that above will not attempt any connection to the server. So you can assert whether the server exists you can evaluate:
```smalltalk
client exists
```

Then you can create a database by asking the interface to create a new database.
```smalltalk
database := client create: 'pharodb`
```

If the database was already created you can also instantiate it by evaluating:
```smalltalk
database := CouchDatabase url: 'http://localhost:5984/pharodb'
```

And then, you're ready to store your first document. You can store anything that can be serialized as JSON. 

By default this CouchDB client sends the `#couchJson` message to objects to convert them to a String with JSON syntax that will be stored as the document.

```smalltalk
document := database create: { 'foo' -> true. 'baz' -> (1 to: 5) } asDictionary 
```

This will return a `CouchDocument` that will contain a dynamically assigned `_id` and other information such as the `_rev` number. And more importantly, you can can ask for the URL of the recently created document.

```smalltalk
document url "http://127.0.0.1:5984/pharodb/36557e332476cf324dd0bcc009005801"
```

Then you can copy that URL and paste it in your web browser of preference, and retrieve the contents of the document.

Note: Even when all documents are stored as JSON, when served by CouchDB they are returned as `text/plain`.

A `CouchDocument` works a wrapper for an object, which by default, as in our above example, is a `Dictionary`.

So in our above sample document, we can do:

```
document object at: 'foo' put: false.
document save
```

This will save the created document and also increment the revision number, which you can query by sending `#revision` to the document.

### Document attachments

All documents can have attachments that will get versioned along the document itself. You can add any file as attachment, you can do it directly by passing the file name, the MIME type and the contents, or by instantiating a `CouchAttachment` object.
The contents are expected to be bytes, so encode and decode strings accordingly.

```smalltalk
self saveAttachmentNamed: 'foo.txt' mimeType: ZnMimeType textPlain contents: 'This is a sample attachment' utf8encoded
```

You can save an attachment with the same name as many times as you want, each time you save it it will increment the revision number of the document.

Every time you query for a `CouchDocument` it will fetch the attached file, but will present them only as stubs without the content.

So, following our example we could do:
```smalltalk
document := CouchDocument url: 'http://127.0.0.1:5984/pharodb/36557e332476cf324dd0bcc009005801'.
document attachments
```

That will return a Dictionary whose keys will be the attachment names and instances of `CouchAttachmentStub` its values. You can send `#download` to an attachment stub to retrieve its full contents.


## Recommendations

Although this guide is small, it is suggested to use the GT Inspector to "dive" into each message send, because CouchDB objects works as containers in the following sequence "Server" -> "Database" -> "Document" -> "Attachment".

