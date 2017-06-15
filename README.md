How to build a document of multiple documents, that can be viewed stand-alone
and may be in nested folder structures?

The problem is discussed here

- https://github.com/asciidoctor/asciidoctor-pdf/issues/93
- https://github.com/asciidoctor/asciidoctor/issues/894

but only uses one level, not nested levels.



# deploy with docker

Run the tool `host_in_containers.sh` from this folder to build html and pdf in
a container and display it in another container.


# How to handle nested structure

If imagesdir is not set, this is currently the top-level document.
Make sure to use images relative to here, then.
If it is set, though, this is a nested document, and then the next hierarchy is
simply added.


```
ifndef::imagesdir[]
:imagesdir: .
endif::[]
:imagesdir: {imagesdir}/chapter2a    # chapter2a is the name of the nested hierarchy
```

## motivation

Question: Why do I care about this?

Answer: Because I want to be able to view each sub-page in an editor such as
atom which provides asciidoc preview.  For this, the image paths must be
relative to this single document.


## alternatives

One could also set the imagespath to the toplevel in each document and then
resolve all image paths from *up there*.  This does not feel clean, though,
because a document in a sub-folder would need to know in what sub-folder it is
located.


## what will not work

The following attempts to append `/chapter2a` only if the `imagesdir` is
already set; otherwise it should only be `chapter2a`.
Unfortunately, it does not work and will set `imagesdir` to `{imagesdir}/chapter2a`.

```
ifdef::imagesdir[]
:imagesdir: {imagesdir}/
endif::[]
:imagesdir: {imagesdir}chapter2a
```
