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

    # Machine instructions and their hex code values.
    INS = {:jns      => 0x0000,
           :load     => 0x1000,
           :store    => 0x2000,
           :add      => 0x3000,
           :subt     => 0x4000,
           :input    => 0x5000,
           :output   => 0x6000,
           :halt     => 0x7000,
           :skipcond => 0x8000,
           :jump     => 0x9000,
           :clear    => 0xA000,
           :addi     => 0xB000,
           :jumpi    => 0xC000,
           :storei   => 0xD000}

    class MachineCode
        def initialize(mem_offset, code)
            @mem_offset = mem_offset
            @code = code
        end

        def to_s
            "offset: #{mem_offset}, code: #{code}"
        end

        attr_reader :mem_offset, :code
    end
end
