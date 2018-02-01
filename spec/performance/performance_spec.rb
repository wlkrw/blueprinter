require 'oj'
RSpec.shared_context 'movie class' do

  # Movie, Actor Classes and serializers
  before(:context) do
    # models
    class Movie
      attr_accessor :id, :name, :release_year, :actor_ids, :owner_id, :movie_type_id

      def actors
        actor_ids.map do |id|
          a = Actor.new
          a.id = id
          a.name = "Test #{a.id}"
          a.email = "test#{a.id}@test.com"
          a
        end
      end

      def movie_type
        mt = MovieType.new
        mt.id = movie_type_id
        mt.name = 'Episode'
        mt
      end
    end

    class Actor
      attr_accessor :id, :name, :email
    end

    class MovieType
      attr_accessor :id, :name
    end

    class ActorsBlueprint < Blueprinter::Base
      fields :name, :email
    end

    class MovieTypesBlueprint < Blueprinter::Base
      field :name
    end

    class MoviesBlueprint < Blueprinter::Base
      fields :name, :release_year
      association :movie_type, blueprint: MovieTypesBlueprint
      association :actors, blueprint: ActorsBlueprint
    end
  end

  let(:movie) do
    m = Movie.new
    m.id = 232
    m.name = 'test movie'
    m.actor_ids = [1, 2, 3]
    m.owner_id = 3
    m.movie_type_id = 1
    m
  end

  def build_movies(count)
    count.times.map do |i|
      m = Movie.new
      m.id = i + 1
      m.name = 'test movie'
      m.actor_ids = [1, 2, 3]
      m.owner_id = 3
      m.movie_type_id = 1
      m
    end
  end
end

describe 'FastJsonapi::ObjectSerializer' do
  include_context 'movie class'

  def print_stats(count, our_time)
    format = '%-15s %-10s %s'
    puts ''
    puts format(format, 'Serializer', 'Records', 'Time')
    puts format(format, 'Blueprinter', count, our_time.round(2).to_s + ' ms')
  end

  context 'Performance' do
    before { Blueprinter.configure { |config| config.generator = Oj } }
    after { Blueprinter.configure { |config| config.generator = JSON } }
    [1, 25, 250, 1000].each do |movie_count|
      speed_factor = 25
      it "should serialize #{movie_count} records atleast #{speed_factor} times faster than AMS" do
        movies = build_movies(movie_count)
        our_json = nil
        our_serializer = MoviesBlueprint
        our_time = Benchmark.measure { our_json = our_serializer.render(movies) }.real * 1000
        print_stats(movie_count, our_time)
      end
    end
  end
end
