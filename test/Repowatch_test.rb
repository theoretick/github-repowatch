#
# tests for Repowatch.rb
#
require_relative './../lib/Repowatch'
require 'minitest/autorun'
require 'minitest/spec'
require "mocha/setup"
require 'nokogiri' # needed for stub

class RepowatchTest < MiniTest::Unit::TestCase

  describe 'repowatch' do

    before do
      @unchecked = RepoWatch.new('octocat/Spoon-Knife')
      @r = RepoWatch.new('octocat/Spoon-Knife')
      @r.checkGithub
      #fake_html and fake_noko for stubbing
      fake_html = %Q{
        <!DOCTYPE html>
        <html>
          <head>
          </head>
          <body>
            <li class="commit commit-group-item js-navigation-item js-details-container">
              <a href="/ShaneDelmore/critic_critic/commit/9cb074b571eafc7f64239f56fdd88f7d91ba7a64" class="message" data-pjax="true">removed unused view files. deleted related tests that are no longer a…</a>
            </li>
          </body>
        </html>
      }
      @fake_noko = Nokogiri::HTML(fake_html)
    end

    it 'should fail to create an instance with 0 arguments' do
      proc {RepoWatch.new()}.must_raise(ArgumentError)
    end

    it 'should create an instance with 1 argument' do
      RepoWatch.new('octocat/Spoon-Knife').must_be_instance_of(RepoWatch)
    end

    it 'should create an instance with 2 arguments' do
      RepoWatch.new('octocat/Spoon-Knife','blar').must_be_instance_of(RepoWatch)
    end

    it 'should correctly parse the path of the  username and repo to watch' do
      @r.path.must_equal('https://github.com/octocat/Spoon-Knife/commits/master')
    end

    it 'should find a message thats a string instance' do
       @r.msg.must_be_kind_of(String)
    end

    it 'should get a response from HTTP query' do
      RepoWatch.any_instance.stubs(:get_response).returns(@fake_noko)
      stubbed = RepoWatch.new('ShaneDelmore/critic_critic')
      assert_equal @fake_noko, stubbed.get_response
    end

    it 'should return False from checkGithub if no new update' do
      @r.checkGithub.must_be_kind_of(FalseClass)
    end

    it 'should return True from checkGithub on first-run' do
      @unchecked.checkGithub.must_be_kind_of(TrueClass)
    end

  end

end
