# Copyright (c) 2011 Matthew Godshall
#
# This file is part of rMARIE.
#
# rMARIE is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# rMARIE is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with rMARIE.  If not, see <http://www.gnu.org/licenses/>.
#

module Rmarie
    class SymbolTable

        # Create a new symbol table.
        #
        def initialize
            @sym = Hash.new
        end

        # Insert the id and its location in the symbol table.
        # TODO Note: Raises an exception if id already has an entry.
        #
        def insert(id, loc)
            @sym[id] = loc
        end

        # Look-up the id's location in the symbol table.
        #
        def lookup(id)
            @sym[id]
        end

        # String representation of the symbol table.
        #
        def to_s
            @sym.to_s
        end
    end
end
