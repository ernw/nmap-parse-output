# nmap-parse-output

## THIRD-PARTY SOFTWARE NOTICES AND INFORMATION

This project incorporates components from the projects listed below. The original copyright notices and the licenses under which ERNW received such components are set forth below.

1. [Nmap Bootstrap XSL](https://github.com/honze-net/nmap-bootstrap-xsl)
2. [XSLTJSON Lite v0.2](https://github.com/bramstein/xsltjson)
3. [nmap.xsl](https://github.com/nmap/nmap)

### 1. Nmap Bootstrap XSL

Used in [command html-bootstrap](nmap-parse-output-xslt/html-bootstrap.xslt)

https://github.com/honze-net/nmap-bootstrap-xsl

```
Creative Commons BY-SA
Andreas Hontzia (@honze_net)
```
### 2. XSLTJSON Lite v0.2

Used in [command to-json](nmap-parse-output-xslt/to-json.xslt)

https://github.com/bramstein/xsltjson/blob/master/conf/xml-to-jsonml.xsl

```
XSLTJSON Lite v0.2 - Transform arbitrary XML to JSONML	

Licensed under the new BSD License.
Copyright 2009, Bram Stein
All rights reserved.
```

### 3. nmap.xsl

Used in [command to-json](nmap-parse-output-xslt/html.xslt)

https://github.com/nmap/nmap/blob/master/docs/nmap.xsl

```
=========================================================================
            nmap.xsl stylesheet version 0.9c
            last change: 2010-12-28
            Benjamin Erb, http://www.benjamin-erb.de
==============================================================================
    Copyright (c) 2004-2006 Benjamin Erb
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:
    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
    3. The name of the author may not be used to endorse or promote products
       derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
    IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
    OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
    IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
    NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
    THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
==========================================================================
```
