require 'spec_helper'

describe 'Github' do
  describe 'Deployments' do
    before(:all) do
      @api_key = ENV['GITHUB_API_KEY']
      @scope = service_instance('github_deployments')
    end

    it 'can list all deployments' do      
      github = Github.new oauth_token: @api_key
      deployment = github.repos.deployments.create 'skierkowski', 'hello' , ref:'terst'
      params = {
        'api_key'  => @api_key,
        'username' => 'skierkowski',
        'repo'     => 'hello'
      }
      @scope.test_action('list', params) do
        return_info = expect_return[:payload]
        expect(return_info).to be_a(Array)
        return_info.each do |release|
          expect(release).to be_a(Hash)
        end
      end
    end

    it 'can create a deployment' do
      github = Github.new oauth_token: @api_key

      params = {
        'api_key'     => @api_key,
        'username'    => 'skierkowski',
        'repo'        => 'hello',
        'ref'         => 'terst'
      }
      @scope.test_action('create', params) do
        return_info = expect_return[:payload]
        expect(return_info).to be_a(Hash)
      end
    end

    describe 'Status' do 
      before :all do
        github = Github.new oauth_token: @api_key
        @deployment = github.repos.deployments.create 'skierkowski', 'hello' , ref:'terst'
      end

      after :all do
      end
      

      it 'can list deployment statuses' do
        params = {
          'api_key'  => @api_key,
          'username' => 'skierkowski',
          'repo'     => 'hello',
          'id'       => @deployment.id
        }
        @scope.test_action('statuses', params) do
          return_info = expect_return[:payload]
          expect(return_info).to be_a(Array)
          return_info.each do |release|
            expect(release).to be_a(Hash)
          end
        end
      end

      it 'can create a deployment status' do
        params = {
          'api_key'     => @api_key,
          'username'    => 'skierkowski',
          'repo'        => 'hello',
          'id'          => @deployment.id,
          'state'       => 'success',
          'description' => 'deployment was successful'
        }
        @scope.test_action('create_status', params) do
          return_info = expect_return[:payload]
          expect(return_info).to be_a(Hash)
        end
      end
    end
  end
end
