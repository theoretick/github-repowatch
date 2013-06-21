#
require_relative Repowatch.rb
require 'minitest/autorun'
require 'minitest/spec'

class RepowatchTest < MiniTest::Unit::TestCase

  describe 'repowatch' do

    before do
      @r = RepoWatch.new
    end

    it 'should create an instance without any arguments' do
      assert_instance_of RepoWatch, RepoWatch.new
    end

  end

end