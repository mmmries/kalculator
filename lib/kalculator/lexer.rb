class Kalculator
  class Lexer < RLTK::Lexer
    rule(/\s/)
    rule(/\(/)       { :LPAREN   }
    rule(/\)/)       { :RPAREN   }
    rule(/\[/)       { :LBRACKET }
    rule(/\]/)       { :RBRACKET }
    rule(/,/)        { :COMMA    }
    rule(/\+/)       { :PLUS     }
    rule(/-/)        { :SUB      }
    rule(/\*/)       { :MUL      }
    rule(/\//)       { :DIV      }
    rule(/>/)        { :GT       }
    rule(/>=/)       { :GTE      }
    rule(/</)        { :LT       }
    rule(/<=/)       { :LTE      }
    rule(/==/)       { :EQ       }
    rule(/AND/)      { :AND      }
    rule(/OR/)       { :OR       }
    rule(/\-?\d+/)      { |t| [:NUMBER, t.to_i] }
    rule(/\-?\.\d+/)    { |t| [:NUMBER, t.to_f] }
    rule(/\-?\d+\.\d+/) { |t| [:NUMBER, t.to_f] }
    rule(/contains/) { |t| :CONTAINS }
    rule(/if/)       { |t| :IF }
    rule(/sum/)      { |t| :SUM }
    rule(/true/)     { |t| :TRUE }
    rule(/false/)    { |t| :FALSE }
    rule(/"[^"]*"/)  { |t| [:STRING, t[1..-2]] }
    rule(/[A-Za-z][A-Za-z0-9\._]*/) { |t| [:IDENT, t] }
  end
end
