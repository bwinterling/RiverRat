require 'spec_helper'

describe "favoriting on homepage" do

  before :each do
    @rivers = {
      :rivers => [
        {:name => "Saco",
         :id => 1}
      ]
    }.to_json
    @gauges = {:gauges => [
      {:geometry => {
        :coordinates => ["10", "11"]
        },
       :run_id => 1},
      {:geometry => {
          :coordinates => ["12", "13"]
        },
       :run_id => 1}
    ]
    }.to_json
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get "/api/v1/rivers.json", {}, @rivers
      mock.get "/api/v1/gauges.json", {}, @gauges
    end
  end

  describe "creating a favorite" do
    describe "for guest user" do
      it "does not show favorite links" do
        visit '/'
        expect(page).to_not have_link('Favorite')
      end
    end

    describe "for a logged in user" do
      before :each do
        user = User.new(:email => "ex@example.com", :password => "foobar")
        register_user(user)
      end

      it "clicking on favorite adds the river to favorites" do
        visit '/'
        within('.river-favorite') do
          click_link('fav')
        end
        within('.user-favorites') do
          expect(page).to have_content('Saco')
        end
      end
    end
  end

  describe "removing a favorite" do
    before :each do
      user = User.new(:email => "ex@example.com", :password => "foobar")
      register_user(user)
    end

    it" clicking on X removes the favorite" do
      visit '/'
      within('.river-favorite') do
        click_link('fav')
      end
      within('.remove-favorite') do
        click_link('unfav')
      end
      within('.user-favorites') do
        expect(page).to_not have_content('Saco')
      end
    end
  end

end
