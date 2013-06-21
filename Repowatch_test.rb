#
require_relative 'Repowatch'
require 'minitest/autorun'
require 'minitest/spec'

class RepowatchTest < MiniTest::Unit::TestCase

  describe 'repowatch' do

    before do
      @r = RepoWatch.new
      @r.checkGithub
    end

    it 'should create an instance without any arguments' do
      RepoWatch.new.must_be_instance_of(RepoWatch)
    end

    it 'should correctly parse the path of the  username and repo to watch' do
      @r.path.must_equal('https://github.com/theoretick/PCS-exam2/commits/master')
    end

    it 'should find a message thats a string instance' do
       @r.msg.must_be_kind_of(String)
    end

    it 'should correctly post notification' do

    end

  end

end
