Resources
=========

*Note: This repository's function changed from a raw resource store (which just hosted the latest resource data in XML and Lua format, compiled from the [Resource Extractor](https://github.com/Windower/ResourceExtractor)) to the place where we host the resource package for Windower 5. As such it will only hold the files relevant for the new package, which are the Lua files. If you still need the XML version of the files you need to run ResourceExtractor yourself and use its output.*

This repository contains the latest version of Windower's resources. These resources are parsed with [Resource Extractor](https://github.com/Windower/ResourceExtractor).

It produces two kinds of resources: automatically parsed resources (from FFXI's DAT files) and manually added resources (from its own [`fixes.xml`](https://github.com/Windower/ResourceExtractor/blob/master/fixes.xml) file).

If you want to help produce new resources after an FFXI update, follow these steps:

1. Update your FFXI client.
2. Run our [Resource Extractor](https://github.com/Windower/ResourceExtractor).
3. It will produce a folder containing the new resources.
  * *Note: If it fails to do so, please [file an issue](https://github.com/Windower/ResourceExtractor/issues/new). Occasionally Square Enix will change some structures and our extractor will break. In that case it will need to be manually adjusted for the changes. We'll get to it as soon as we can.*
4. Submit a pull request to this repository containing the new resources. If you don't know how that works, check out one of the many guides online.

If you want to add a new category of resources, or add new attributes for existing resources, please adjust the [Resource Extractor](https://github.com/Windower/ResourceExtractor) program and submit a pull request (ideally for both the Resource Extractor repository as well as this one with the new resources). If you're not a developer, please suggest any new features on its [issue tracker](https://github.com/Windower/ResourceExtractor/issues). We will try to implement it when we get the chance.

Some resources are not parsed from FFXI's DAT files, but generated from a file we maintain manually. That file is the previously mentioned [`fixes.xml`](https://github.com/Windower/ResourceExtractor/blob/master/fixes.xml). Please submit all changes to those types of resources as pull requests for that file.
