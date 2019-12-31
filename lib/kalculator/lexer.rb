class Kalculator
  class Lexer < RLTK::Lexer
    rule(/\s/)
    rule(/\./)       { :PERIOD   }
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
    rule(/!=/)       { :NEQ      }
    rule(/and/)      { :AND      }
    rule(/or/)       { :OR       }
    rule(/AND/)      { :AND      }
    rule(/OR/)       { :OR       }
    rule(/!/)        { :BANG     }
    rule(/\-?\d+%/)      { |t| [:PERCENT, t.to_i] }
    rule(/\-?\.\d+%/)    { |t| [:PERCENT, t.to_f] }
    rule(/\-?\d+\.\d+%/) { |t| [:PERCENT, t.to_f] }
    rule(/\-?\d+/)      { |t| [:NUMBER, t.to_i] }
    rule(/\-?\.\d+/)    { |t| [:NUMBER, t.to_f] }
    rule(/\-?\d+\.\d+/) { |t| [:NUMBER, t.to_f] }
    rule(/exists/)   { |t| :EXISTS }
    rule(/if/)       { |t| :IF }
    rule(/true/)     { |t| :TRUE }
    rule(/false/)    { |t| :FALSE }
    rule(/null/)     { |t| :NULL }
    rule(/TRUE/)     { |t| :TRUE }
    rule(/FALSE/)    { |t| :FALSE }
    rule(/NULL/)     { |t| :NULL }
    rule(/"[^"]*"/)  { |t| [:STRING, t[1..-2]] }
    rule(/[A-Za-z][A-Za-z0-9_]*/) { |t| [:IDENT, t] }
  end
end
