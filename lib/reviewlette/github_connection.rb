require 'yaml'
require 'octokit'

module Reviewlette

  class GithubConnection

    GITHUB_CONFIG = YAML.load_file("#{File.dirname(__FILE__)}/../../config/.github.yml")

    attr_accessor :client, :repo

    def initialize
      gh_connection
    end

    def gh_connection
      @client = Octokit::Client.new(:access_token => GITHUB_CONFIG['token'])
    end

    def get_branch_name(pr_id, repo)
      @client.pull_requests(repo)[pr_id].head.ref
    end

    def list_pulls(repo)
      @client.pull_requests(repo)
    end

    def pull_merged?(repo, number)
      client.pull_merged?(repo, number)
    end

    def add_assignee(repo, number, title, body, name)
      @client.update_issue(repo, number, title, body, :assignee => name)
    end

    def comment_on_issue(repo, number, name, trello_card_url)
      @client.add_comment(repo, number, "@#{name} is your reviewer :thumbsup: check #{trello_card_url}")
    end

    def list_issues(repo)
      @client.list_issues(repo)
    end

  end
end