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
class Lexer
option
    ignorecase
macro
    BLANK   \s+
    COMMA   \,
    COMMENT \/.*\n
    INT     \d+
    HEX     0[xX][0-9a-fA-F]+
    IDENT   ([a-zA-Z][a-zA-Z0-9]*)
rule
      {COMMENT}
      {BLANK}  
      {COMMA}  { [',',','] }
      {HEX}    { [:HEX, text.to_i(16)] }
      -?{INT}  { [:INT, text.to_i] }
      {IDENT}  { if text =~ /^(load|store|storei|add|addi|subt|jump|jumpi|jns|skipcond)$/i
                    [:UNOP, text.downcase.to_sym]
                 elsif text =~ /^(input|output|halt|clear)$/i
                    [:OP, text.downcase.to_sym]
                 elsif text =~ /^dec$/i
                    [:T_DEC, :dec]
                 elsif text =~ /^hex$/i
                    [:T_HEX, :hex]
                 elsif text =~ /^org$/i
                    [:ORG, nil]
                 else
                    [:LABEL, text]
                 end
               }
end
