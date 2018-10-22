require_relative '../rails_test_helper'
require_relative '../factories/model_factories.rb'

describe '::Base' do
  describe '::render' do
    context 'Outside Rails project' do
      context 'Given passed object is a Hash' do
        let(:obj) do
          {
            id: 1,
            first_name: 'Meg',
            last_name: 'Ryan'
          }
        end

        let(:blueprint_with_block) do
          Class.new(Blueprinter::Base) do
            _swagger type: "integer", description: "ID"
            identifier :id

            _swagger type: "string", description: "The full, first and last, name of the user."
            field :full_name do |user|
              "#{user[:first_name]} #{user[:last_name]}"
            end
          end
        end

        it "generates swagger successfully" do
          expected_swagger = {
            type: "object",
            properties: {
              id: {
                type: "integer",
                description: "ID"
              },
              full_name: {
                type: "string",
                description: "The full, first and last, name of the user."
              }
            }
          }
          binding.pry
          expect(blueprint_with_block.swagger_definition).to eq(expected_swagger)
        end
      end
    end
  end
end
