module Fire

  class NestedModel < Model
    non_shared_cattr_accessor :parent, :nested_options

    def saving_data
      res = data.clone
      self.class.parent.all_path_keys.each do |k|
        res.delete(k)
      end
      res
    end

    class << self
      def in_collection(name)
        raise 'can not set a collection for Nested Model'
      end

      def nested_in(parent, options)
        self.parent = parent
        self.nested_options = OpenStruct.new(options)
        self.parent.has_nested(self)
      end

      def own_path_keys
        parent.all_path_keys + [ nested_options.folder ] + super()
      end

      def collection_name
        parent.collection_name
      end
    end

    def method_missing(*args)
      if args.first.to_s == self.class.nested_options.folder
        self.class.nested_options.folder
      else
        super
      end
    end

  end

end
