class Kalculator
  module Transform
    def self.run(node, &block)
      new_node = yield node
      if is_terminal?(new_node)
        new_node
      elsif new_node.first.is_a?(Symbol)
        args = new_node[1..-1].map{ |arg| run(arg, &block) }
        args.unshift(new_node.first)
      else
        new_node.map{|node| run(node, &block) }
      end
    end

    def self.is_terminal?(node)
      return false if node.is_a?(Array)
      true
    end
  end
end
