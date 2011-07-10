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
    class Memory
        
        # Create new memory instance.
        #
        def initialize
            @@MEM_SIZE = 4095
            @@MEM_BLOCK_SIZE = 15
            @@MEM_NUM_BLOCKS = 255

            @@mem = []
            @@mem.fill(0, 0..@@MEM_SIZE)
        end
    
        # Read data from the given address.
        #
        def read(addr)
            @@mem[addr]
        end
    
        # Write data to the address in memory.
        #
        def write(addr, data)
            @@mem[addr] = data
        end

        # Dumps the contents of memory to string based on desired verbosity.
        # 
        # Passing true will give a complete dump of memory, while false gives
        # a truncated dump featuring only non-zero blocks.
        #
        def dump(verbose)
            header = generate_header 
            body = generate_body verbose

            header << body
        end

        private

        # Generate header for memory dump.
        #
        def generate_header
            header = "Memory\n======\n    \t"

            # Generate column headers.
            for i in 0..@@MEM_BLOCK_SIZE
                header << "+%x   " % i
            end

            header << "\n"
        end

        # Generate body for memory dump.
        #
        # Passing false generates a truncated dump, while true generates a
        # complete memory dump.
        #
        def generate_body(v)
            verbose = v
            trunc = false
            line = ""
            loc = 0
            body = ""

            for m in 0..@@MEM_NUM_BLOCKS
                # Get starting address.
                line << "%04x\t" % loc

                # Get data from block.
                for n in 0..@@MEM_BLOCK_SIZE
                    val = @@mem[loc]

                    # Check if the data at 'loc' is zero.
                    if val.zero?
                        verbose = verbose || false
                        line << "%04x " % @@mem[loc]
                    else
                        verbose = verbose || true
                        line << "%04x " % @@mem[loc]
                    end

                    loc = loc.next
                end

                # Check if we encountered non-zero values.
                if verbose
                    body = body << line << "\n"
                    trunc = false
                else
                    if not trunc
                        body = body << "...\n"                          
                        trunc = true
                    end
                end

                # Reset our line.
                verbose = v
                line.clear
            end
            
            body
        end
    end
end
