$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'dde'
require 'spec'
require 'spec/autorun'

# Customize RSpec with my own extensions
module SpecMacros

  # wrapper for it method that extracts description from example source code, such as:
  # spec { use{    function(arg1 = 4, arg2 = 'string')  }}
  def spec &block
    it description_from(*block.source_location), &block
  end

  # reads description line from source file and drops external brackets (like its{}, use{}
  def description_from(file, line)
      File.open(file) do |f|
        f.lines.to_a[line-1].gsub( /(spec.*?{)|(use.*?{)|}/, '' ).strip
      end
  end
end

Spec::Runner.configure { |config| config.extend(SpecMacros) }

module DDETest
  # Helper methods:
  def use
    lambda {yield}.should_not raise_error
  end

  def any_block
    lambda {|*args| args}
  end

  def dde_cmd
    APPCLASS_STANDARD
  end

  def dde_callback
    @dde_callback ||= Win32::API::Callback.new('IIPPPPPP', 'L'){|*args| }
  end
end