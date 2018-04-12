class Kalculator
  class Parser < RLTK::Parser
    #Left     200 '&&' '||'.
    left :GT, :GTE, :LT, :LTE, :EQ
    left :PLUS, :SUB
    left :MUL, :DIV
    #Left     600 '.'.

    production(:expression) do
      clause('IF LPAREN expression COMMA expression COMMA expression RPAREN') do |_, _, condition, _, true_clause, _, false_clause, _|
        [:if, condition, true_clause, false_clause]
      end
      clause('SUM LPAREN expression RPAREN') do |_, _, e0, _|
        [:sum, e0]
      end
      clause('LPAREN expression RPAREN') { |_, expression, _| expression }

      clause('NUMBER') { |n| [:number, n] }
      clause('IDENT') { |n| [:variable, n.split(".")] }
      clause('TRUE') { |n| [:boolean, true] }
      clause('FALSE') { |n| [:boolean, false] }

      clause('expression GT expression') { |e0, _, e1| [:>, e0, e1] }
      clause('expression GTE expression') { |e0, _, e1| [:>=, e0, e1] }
      clause('expression LT expression') { |e0, _, e1| [:<, e0, e1] }
      clause('expression LTE expression') { |e0, _, e1| [:<=, e0, e1] }
      clause('expression EQ expression') { |e0, _, e1| [:==, e0, e1] }

      clause('expression PLUS expression') { |e0, _, e1| [:+, e0, e1] }
      clause('expression SUB expression')  { |e0, _, e1| [:-, e0, e1] }
      clause('expression MUL expression')  { |e0, _, e1| [:*, e0, e1] }
      clause('expression DIV expression')  { |e0, _, e1| [:/, e0, e1] }
    end

    finalize()
  end
end
