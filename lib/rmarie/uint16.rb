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
    class UInt16

        # Convert to an unsigned 16-bit integer.
        # n - signed 16-bit integer
        #
        def self.from_signed n
            n & 0xFFFF
        end
        
        # Convert to a signed 16-bit integer.
        # n - unsigned 16-bit integer
        #
        def self.to_signed n
            if n & 0x8000 == 0x8000
                n - 0x1_0000
            else
                n
            end
        end
    end
end
