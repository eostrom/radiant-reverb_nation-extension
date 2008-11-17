require 'autotest/rails'

Autotest.add_discovery do
  "rails"
end

class Autotest
  def consolidate_failures(failed)
    filters = new_hash_of_arrays

    class_map = Hash[*self.find_order.grep(/^test/).map { |f| # TODO: ugly
                       [path_to_classname(f), f]
                     }.flatten]
    class_map.merge!(self.extra_class_map)

#    puts "AUTOTEST #{class_map.inspect}"
    failed.each do |method, klass|
      klass.sub!(/(.Test)::.*/, '\1')
#      puts "AUTOTEST #{klass.inspect} #{method.inspect}"
      if class_map.has_key? klass then
        filters[class_map[klass]] << method
      else
        output.puts "Unable to map class #{klass} to a file"
      end
    end

    return filters
  end
end

class Autotest::Rails
  # Convert the pathname s to the name of class.
  def path_to_classname(s)
    sep = File::SEPARATOR
    f = s.sub(/^test#{sep}((unit|functional|integration|views|controllers|helpers)#{sep})?/, '').sub(/\.rb$/, '').split(sep)
    f = f.map { |path| path.split(/_/).map { |seg| seg.capitalize }.join }
    f.last.sub!(/(Test)?$/, 'Test')
    f.join('::')
  end
end
