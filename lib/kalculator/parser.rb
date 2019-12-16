require "kalculator/types"
class Kalculator
  class Parser < RLTK::Parser
    left :AND, :OR
    left :GT, :GTE, :LT, :LTE, :EQ
    left :PLUS, :SUB
    left :MUL, :DIV
    #Left     600 '.'.

    production(:expression) do
      clause('IF LPAREN expression COMMA expression COMMA expression RPAREN') do |_, _, condition, _, true_clause, _, false_clause, _|
        [:if, condition, true_clause, false_clause, nil]
      end
      clause('EXISTS LPAREN IDENT RPAREN') do |_, _, n, _|
        [:exists, [:variable, n]]
      end
      clause('LPAREN expression RPAREN') { |_, expression, _| expression }
      clause('LBRACKET expressions RBRACKET') { |_, expressions, _| [:list, expressions, List] }
      clause('IDENT LPAREN expressions RPAREN') { |fn_name, _, expressions, _| [:fn_call, fn_name, expressions, nil] }

      clause('NUMBER') { |n| [:number, n, Number] }
      clause('PERCENT') { |n| [:percent, n, Percent] }
      clause('STRING') { |s| [:string, s, String] }
      clause('IDENT') { |n| [:variable, n, Object] }
      clause('TRUE') { |n| [:boolean, true, Bool] }
      clause('FALSE') { |n| [:boolean, false, Bool] }
      clause('NULL') { |n| [:null, nil, Object] }

      clause('expression PERIOD IDENT')  {  |e0, _, i| [:access,i, e0, nil] }
      clause('expression GT expression') { |e0, _, e1| [:>, e0, e1, Bool] }
      clause('expression GTE expression') { |e0, _, e1| [:>=, e0, e1, Bool] }
      clause('expression LT expression') { |e0, _, e1| [:<, e0, e1, Bool] }
      clause('expression LTE expression') { |e0, _, e1| [:<=, e0, e1, Bool] }
      clause('expression EQ expression') { |e0, _, e1| [:==, e0, e1, Bool] }
      clause('expression NEQ expression') { |e0, _, e1| [:!=, e0, e1, Bool] }

      clause('expression AND expression') { |e0, _, e1| [:and, e0, e1, Bool] }
      clause('expression OR expression') { |e0, _, e1| [:or, e0, e1, Bool] }

      clause('expression PLUS expression') { |e0, _, e1| [:+, e0, e1, Number] }
      clause('expression SUB expression')  { |e0, _, e1| [:-, e0, e1, Number] }
      clause('expression MUL expression')  { |e0, _, e1| [:*, e0, e1, Number] }
      clause('expression DIV expression')  { |e0, _, e1| [:/, e0, e1, Number] }

      clause('BANG expression')           { |_, e0| [:not, e0, Bool] }
    end

    production(:expressions) do
      clause('expression') { |expression| [expression] }
      clause('expression COMMA expressions') { |expression, _, expressions| [expression].concat(expressions) }
    end

    finalize()
  end
end
