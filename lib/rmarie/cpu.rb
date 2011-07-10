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
    class CPU
        attr_accessor :ir, :pc, :ac, :mar, :mbr, :in, :out
    
        # Create CPU instance and initialize registers to 0.
        #
        def initialize
            @ir = 0
            @pc = 0
            @ac = 0
            @mar = 0
            @mbr = 0
            @in = 0
            @out = 0
        end

        # Dump registers to string for use in the final machine state dump.
        #
        def dump
            "Registers\n" <<
            "=========\n" <<
            "ir  = %04x\n" % @ir <<
            "pc  = %04x\n" % @pc <<
            "ac  = %04x\n" % @ac <<
            "mar = %04x\n" % @mar <<
            "mbr = %04x\n" % @mbr <<
            "in  = %04x\n" % @in <<
            "out = %04x\n" % @out <<
            "\n\n"
        end
    end
end
