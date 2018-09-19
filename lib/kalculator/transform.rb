class Kalculator
  module Transform
    def self.run(node, &block)
      new_node = yield node
      return new_node if is_terminal?(new_node)
      args = new_node[1..-1].map{ |arg| run(arg, &block) }
      args.unshift(new_node.first)
    end

    def self.is_terminal?(node)
      return false if node.is_a?(Array) && node.first.is_a?(Symbol)
      true
    end
  end
end
