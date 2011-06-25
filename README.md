rMARIE
===========

rMARIE is a simple computer based on the specification of MARIE in
"The Essentials of Computer Organization and Architecture". The virtual
machine has 4K words of main memory, with 16-bit data and instructions.
It has several registers, but only one general purpose register.

This implementation features a new machine instruction, 'storei', with
two more planned in future updates.

Besides the addition of machine instructions, the assembly language definition
differs slightly. Addresses can now be given as labels, hexadecimal digits
(ex: 0xCAFE), or decimal digits.

Features
--------

* Assembler (supports .mas files)
* Virtual Machine  (only supports .rmex files)

To Do
----

* Actual documentation.
* Create tests.
* Add actual error handling to the parser.
* Many, many things... sooo many things.

Usage
-----

To assemble an rMARIE assembly file:

    rmarie-asm <file>.mas

This will produce *file.rmex*, which you can now give to the virtual machine:

    rmarie-vm <file>.rmex


Examples
--------

See the *examples* folder for assembly source examples.

Requirements
------------

* Ruby (>= 1.9.0)
* Racc
* Rexical

Install
-------

* Clone the rMARIE repository.
* `gem build rmarie.gemspec`
* `sudo gem install rMARIE-version.gem`

Author
------

Original author: Matthew Godshall

License
-------

For the full license, see the *LICENSE* file.

(GPL v3 License)

Copyright (c) 2011 Matthew Godshall

rMARIE is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

rMARIE is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with rMARIE.  If not, see <http://www.gnu.org/licenses/>.
