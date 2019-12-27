
class Kalculator
  class Parser < RLTK::Parser
    #code taken from spiff-rb
    class Environment < Environment
      def metadata(first_token = nil, last_token = nil)
        first_token ||= @positions.first
        last_token  ||= @positions.last
        begins_at = first_token.stream_offset
        ends_at   = last_token.stream_offset + last_token.length - 1
        {
          offset: begins_at..ends_at,
        }
      end
    end
    left :AND, :OR
    left :GT, :GTE, :LT, :LTE, :EQ, :NEQ
    left :PLUS, :SUB
    left :MUL, :DIV
    left :PERIOD
    #Left     600 '.'.

    production(:expression) do
      clause('IF LPAREN expression COMMA expression COMMA expression RPAREN') do |_, _, condition, _, true_clause, _, false_clause, _|
        [:if, condition, true_clause, false_clause, metadata]
      end
      clause('EXISTS LPAREN IDENT RPAREN') do |_, _, n, _|
        [:exists, n, metadata]
      end
      clause('LPAREN expression RPAREN') { |_, expression, _| expression }
      clause('LBRACKET expressions RBRACKET') { |_, expressions, _| [:list, expressions, metadata] }
      clause('IDENT LPAREN expressions RPAREN') { |fn_name, _, expressions, _| [:fn_call, fn_name, expressions, metadata] }
      clause('expression LBRACKET STRING RBRACKET') { |object, _,ident, _| [:access, ident, object, metadata]}

      clause('NUMBER') { |n| [:number, n, Number, metadata] }
      clause('PERCENT') { |n| [:percent, n, Percent, metadata] }
      clause('STRING') { |s| [:string, s, String.new, metadata] }
      clause('IDENT') { |n| [:variable, n, metadata] }
      clause('TRUE') { |n| [:boolean, true, Bool, metadata] }
      clause('FALSE') { |n| [:boolean, false, Bool, metadata] }
      clause('NULL') { |n| [:null, nil, Object, metadata] }

      clause('expression PERIOD IDENT')  {  |e0, _, i| [:access,i, e0, metadata] }
      clause('expression GT expression') { |e0, _, e1| [:>, e0, e1, metadata] }
      clause('expression GTE expression') { |e0, _, e1| [:>=, e0, e1, metadata] }
      clause('expression LT expression') { |e0, _, e1| [:<, e0, e1, metadata] }
      clause('expression LTE expression') { |e0, _, e1| [:<=, e0, e1, metadata] }
      clause('expression EQ expression') { |e0, _, e1| [:==, e0, e1, metadata] }
      clause('expression NEQ expression') { |e0, _, e1| [:!=, e0, e1, metadata] }

      clause('expression AND expression') { |e0, _, e1| [:and, e0, e1, metadata] }
      clause('expression OR expression') { |e0, _, e1| [:or, e0, e1, metadata] }

      clause('expression PLUS expression') { |e0, _, e1| [:+, e0, e1, metadata] }
      clause('expression SUB expression')  { |e0, _, e1| [:-, e0, e1, metadata] }
      clause('expression MUL expression')  { |e0, _, e1| [:*, e0, e1, metadata] }
      clause('expression DIV expression')  { |e0, _, e1| [:/, e0, e1, metadata] }

      clause('BANG expression')           { |_, e0| [:not, e0, metadata] }
    end

    production(:expressions) do
      clause('expression') { |expression| [expression] }
      clause('expression COMMA expressions') { |expression, _, expressions| [expression].concat(expressions) }
    end

    finalize()

    def metadata(num_tokens)
      {offset: pos(0).stream_offset..pos(num_tokens-1).stream_offset}
    end
  end
end
