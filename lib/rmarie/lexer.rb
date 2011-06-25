#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.5
# from lexical definition file "lexer.rex".
#++

require 'racc/parser'
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
class Lexer < Racc::Parser
  require 'strscan'

  class ScanError < StandardError ; end

  attr_reader   :lineno
  attr_reader   :filename
  attr_accessor :state

  def scan_setup(str)
    @ss = StringScanner.new(str)
    @lineno =  1
    @state  = nil
  end

  def action
    yield
  end

  def scan_str(str)
    scan_setup(str)
    do_parse
  end
  alias :scan :scan_str

  def load_file( filename )
    @filename = filename
    open(filename, "r") do |f|
      scan_setup(f.read)
    end
  end

  def scan_file( filename )
    load_file(filename)
    do_parse
  end


  def next_token
    return if @ss.eos?
    
    # skips empty actions
    until token = _next_token or @ss.eos?; end
    token
  end

  def _next_token
    text = @ss.peek(1)
    @lineno  +=  1  if text == "\n"
    token = case @state
    when nil
      case
      when (text = @ss.scan(/\/.*\n/i))
        ;

      when (text = @ss.scan(/\s+/i))
        ;

      when (text = @ss.scan(/\,/i))
         action { [',',','] }

      when (text = @ss.scan(/-?\d+/i))
         action { [:INT, text.to_i] }

      when (text = @ss.scan(/'0'[xX][0-9a-fA-F]+/i))
         action { [:HEX, text.to_i(16)] }

      when (text = @ss.scan(/(load|store|add|subt|jump)/i))
         action { [:UNOP, text.downcase.to_sym] }

      when (text = @ss.scan(/(input|output|halt)/i))
         action { [:OP, text.downcase.to_sym] }

      when (text = @ss.scan(/org/i))
         action { [:ORG, nil] }

      when (text = @ss.scan(/skipcond/i))
         action { [:SKIP, text.downcase.to_sym] }

      when (text = @ss.scan(/dec/i))
         action { [:T_DEC, text.downcase.to_sym] }

      when (text = @ss.scan(/hex/i))
         action { [:T_HEX, text.downcase.to_sym] }

      when (text = @ss.scan(/([a-zA-Z][a-zA-Z0-9]*)/i))
         action { [:LABEL, text] }

      else
        text = @ss.string[@ss.pos .. -1]
        raise  ScanError, "can not match: '" + text + "'"
      end  # if

    else
      raise  ScanError, "undefined state: '" + state.to_s + "'"
    end  # case state
    token
  end  # def _next_token

end # class
