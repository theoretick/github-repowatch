#
require_relative 'Repowatch'
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

    it 'should correctly parse the path of the  username and repo to watch' do
      assert_equal @r.path, 'https://github.com/theoretick/PCS-exam2/commits/master'
    end

  end

end
