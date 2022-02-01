module BxBlockActivityFeed
  class ActivityFeedsController < ApplicationController
    before_action :validate_json_web_token, only: :account_feeds
    before_action :fetch_feed, only: :show

    def index
      feeds = PublicActivity::Activity.all
      feed_response(feeds)
    end

    def account_feeds
      feeds = PublicActivity::Activity.where(
        owner_type: 'AccountBlock::Account', owner_id: current_user.id
      )
      feed_response(feeds)
    end

    def show
      render json: {feed: @feed.as_json, code: 200}
    end

    private
    def feed_response(feeds)
      if feeds.present?
        render json: {
          activities: feeds.map{ |feed|
            feed.as_json.merge(trackable: find_trackable(feed), owner: find_owner(feed))
          }, code: 200
        }
      else
        render json: {message: "No Records found", code: 200}
      end
    end

    def find_trackable(feed)
      trackable = feed.trackable
    end

    def find_owner(feed)
      trackable = feed.owner
    end

    def fetch_feed
      @feed = PublicActivity::Activity.find(params[:id])
    end
  end
end
