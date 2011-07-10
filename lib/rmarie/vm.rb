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

require 'rmarie/cpu'
require 'rmarie/memory'
require 'rmarie/machinecode'
require 'rmarie/uint16'

module Rmarie
    class VM

        # Initialize the virtual machine.
        # dump - a boolean which controls the verbosity of the dump output
        #        true  = full memory dump
        #        false = truncated memory dump
        #
        def initialize dump
            @cpu = CPU.new
            @mem = Memory.new
            @dump = dump
            @conv = UInt16
            @halted = false
        end

        # Load a machine code object into memory.
        #
        def load_program mcode
            @cpu.pc = mcode.mem_offset
            loc = mcode.mem_offset
            mcode.code.map do |s|
                @mem.write(loc, s)
                loc = loc.next
            end
        end

        # Begins fetch, decode, execute cycle and continues until it halts.
        #
        def start_vm

            # Begin fetch, decode, execute cycle.
            while not @halted
                @cpu.mar = @cpu.pc
                @cpu.ir = @mem.read @cpu.mar
                @cpu.pc = @cpu.pc.next

                case decode_inst @cpu.ir
                    when 0x0000 then jns
                    when 0x1000 then load
                    when 0x2000 then store
                    when 0x3000 then add
                    when 0x4000 then subt
                    when 0x5000 then input
                    when 0x6000 then output
                    when 0x7000 then halt
                    when 0x8000 then skipcond
                    when 0x9000 then jump
                    when 0xA000 then clear
                    when 0xB000 then addi 
                    when 0xC000 then jumpi
                    when 0xD000 then storei
                end
            end
        end

        # Display a dump of the CPU registers and memory contents.
        #
        def dump
            STDOUT.print @cpu.dump << (@mem.dump @dump)
        end

        private

        # Retrieve the instruction bits.
        #
        def decode_inst data
            0xF000 & data
        end

        # Retrieve the address bits.
        #
        def decode_addr data
            0x0FFF & data
        end

        # Perform a jump and store, which stores the current program counter
        # register value at the given address and starts execution at the
        # address proceeding the storage location.
        #
        def jns
            @cpu.mbr = @cpu.pc
            @cpu.mar = decode_addr @cpu.ir
            @mem.write @cpu.mar, @cpu.mbr
            @cpu.mbr = @cpu.mar
            @cpu.ac = 1
            @cpu.ac = @cpu.ac + @cpu.mbr
            @cpu.pc = @cpu.ac
        end

        # Loads data from address to the accumulator register.
        #
        def load
            @cpu.mar = decode_addr @cpu.ir
            @cpu.mbr = @mem.read @cpu.mar
            @cpu.ac = @cpu.mbr
        end

        # Store data in the accumulator to the given address.
        #
        def store
            @cpu.mar = decode_addr @cpu.ir
            @cpu.mbr = @cpu.ac
            @mem.write @cpu.mar, @cpu.mbr
        end

        # Add value at given address to the accumulator.
        #
        def add
            @cpu.mar = decode_addr @cpu.ir
            @cpu.mbr = @mem.read @cpu.mar
            @cpu.ac = @conv.from_signed(@conv.to_signed(@cpu.ac) + @conv.to_signed(@cpu.mbr))
        end

        # Subtract value at given address from the accumulator.
        #
        def subt
            @cpu.mar = decode_addr @cpu.ir
            @cpu.mbr = @mem.read @cpu.mar
            @cpu.ac = @conv.from_signed(@conv.to_signed(@cpu.ac) - @conv.to_signed(@cpu.mbr))
        end

        # Reads an integer, in decimal or hexadecimal, into the input register.
        # If a valid decimal or hexadecimal digit is not provided, then 0 is
        # placed into the input register.
        #
        # Note: Decimal digits must be between -32768 and 32767.
        #       Hexadecimal digits must be between 0x0 and 0xFFFF.
        #       Otherwise input is truncated.
        #
        def input
            STDOUT.print "VM requesting input: "
            v = STDIN.gets
            if v =~ /^0x[0-9a-f]+$/i
                @cpu.in = v.to_i(16) & 0xFFFF
            elsif v =~ /^-?\d+$/
                @cpu.in = v.to_i & 0xFFFF
            else
                @cpu.in = 0
            end
                
            @cpu.ac = @cpu.in
        end

        # Outputs the current value in AC in hexadecimal.
        #
        def output
            @cpu.out = @cpu.ac
            STDOUT.print "VM output: %04x\n" % @cpu.out
        end

        # Halts the execution of the virtual machine.
        #
        def halt
            @halted = true
        end

        # Conditionally skip next instruction.
        #
        #   If 0x0000 is given, skip if accumulator is less than zero.
        #   If 0x0400 is given, skip is accumulator is zero.
        #   If 0x0800 is given, skip if accumulator is greater than zero.
        #
        #   If all three bits are set (0x0c00) the behavior is undefined,
        #   so we halt.
        #
        def skipcond
            case @cpu.ir & 0x0c00
                when 0x0000 then @cpu.pc = @cpu.pc.next if @cpu.ac < 0
                when 0x0400 then @cpu.pc = @cpu.pc.next if @cpu.ac.zero?
                when 0x0800 then @cpu.pc = @cpu.pc.next if @cpu.ac > 0
                else @halted = true
            end
        end

        # Jump to given address.
        #
        def jump
            @cpu.pc = decode_addr @cpu.ir
        end

        # Reset the accumulator to zero.
        #
        def clear
            @cpu.ac = 0
        end

        # Use the value at the address given as the address of the value
        # to add to the accumulator.
        #
        def addi
            @cpu.mar = decode_addr @cpu.ir
            @cpu.mbr = @mem.read @cpu.mar
            @cpu.mar = @cpu.mbr
            @cpu.mbr = @mem.read @cpu.mar
            @cpu.ac = @cpu.ac + @cpu.mbr
        end

        # Use use the value at the address given as the jump address.
        #
        def jumpi
            @cpu.mar = decode_addr @cpu.ir
            @cpu.mbr = @mem.read @cpu.mar
            @cpu.pc = @cpu.mbr
        end

        # Loads the address given, and uses the value at that address as the
        # storage location for the value in the AC.
        #
        def storei
            @cpu.mar = decode_addr @cpu.ir
            @cpu.mbr = @mem.read @cpu.mar
            @cpu.mar = @cpu.mbr
            @cpu.mbr = @cpu.ac
            @mem.write @cpu.mar, @cpu.mbr
        end
    end
end
