class Kalculator
  class Parser < RLTK::Parser
    left :AND, :OR
    left :GT, :GTE, :LT, :LTE, :EQ
    left :PLUS, :SUB
    left :MUL, :DIV
    #Left     600 '.'.

    production(:expression) do
      clause('CONTAINS LPAREN expression COMMA expression RPAREN') do |_, _, collection, _, item, _|
        [:contains, collection, item]
      end
      clause('IF LPAREN expression COMMA expression COMMA expression RPAREN') do |_, _, condition, _, true_clause, _, false_clause, _|
        [:if, condition, true_clause, false_clause]
      end
      clause('SUM LPAREN expression RPAREN') do |_, _, e0, _|
        [:sum, e0]
      end
      clause('COUNT LPAREN expression RPAREN') do |_, _, e0, _|
        [:count, e0]
      end
      clause('LPAREN expression RPAREN') { |_, expression, _| expression }
      clause('LBRACKET expressions RBRACKET') { |_, expressions, _| [:list, expressions] }

      clause('NUMBER') { |n| [:number, n] }
      clause('STRING') { |s| [:string, s] }
      clause('IDENT') { |n| [:variable, n] }
      clause('TRUE') { |n| [:boolean, true] }
      clause('FALSE') { |n| [:boolean, false] }

      clause('expression GT expression') { |e0, _, e1| [:>, e0, e1] }
      clause('expression GTE expression') { |e0, _, e1| [:>=, e0, e1] }
      clause('expression LT expression') { |e0, _, e1| [:<, e0, e1] }
      clause('expression LTE expression') { |e0, _, e1| [:<=, e0, e1] }
      clause('expression EQ expression') { |e0, _, e1| [:==, e0, e1] }
      clause('expression NEQ expression') { |e0, _, e1| [:!=, e0, e1] }

      clause('expression AND expression') { |e0, _, e1| [:and, e0, e1] }
      clause('expression OR expression') { |e0, _, e1| [:or, e0, e1] }

      clause('expression PLUS expression') { |e0, _, e1| [:+, e0, e1] }
      clause('expression SUB expression')  { |e0, _, e1| [:-, e0, e1] }
      clause('expression MUL expression')  { |e0, _, e1| [:*, e0, e1] }
      clause('expression DIV expression')  { |e0, _, e1| [:/, e0, e1] }

      clause('BANG expression')           { |_, e0| [:not, e0] }
    end

    production(:expressions) do
      clause('expression') { |expression| [expression] }
      clause('expression COMMA expressions') { |expression, _, expressions| [expression].concat(expressions) }
    end

    finalize()
  end
end
