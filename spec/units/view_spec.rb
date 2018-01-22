describe '::View' do
  let(:view) { Blueprinter::View.new('Basic View') }
  let(:field) { MockField.new(:first_name) }
  let(:blueprinter_error) { Blueprinter::BlueprinterError }

  describe '#include_view(:view_name)' do
    it 'should return [:view_name]' do
      expect(view.include_view(:extended)).to eq([:extended])
    end
    it 'should set #included_view_names to [:view_name]' do
      view.include_view(:extended)
      expect(view.included_view_names).to eq([:extended])
    end
  end

  describe '#exclude_field(:view_name)' do
    it 'should return [:view_name]' do
      expect(view.exclude_field(:last_name)).to eq([:last_name])
    end
    it 'should set #excluded_field_names to [:view_name]' do
      view.exclude_field(:last_name)
      expect(view.excluded_field_names).to eq([:last_name])
    end
  end

  describe '#<<(field)' do
    context 'Given a field that does not exist' do
      it('should return field') { expect(view << field).to eq(field) }
      it('should set #fields to {field.name => field}') do
        view << field
        expect(view.fields).to eq({first_name: field})
      end
    end

    context 'Given a field that already exists' do
      before { view << field }
      it { expect { view << field }.to raise_error(blueprinter_error) }
      it 'should not set #fields' do
        expect(view.fields).to eq({first_name: field})
      end
    end
  end

  describe '#fields' do
    context 'Given no fields' do
      it { expect(view.fields).to eq({}) }
    end

    context 'Given existing fields' do
      before { view << field }
      it('should eq {field.name => field}') do
        expect(view.fields).to eq({first_name: field})
      end
    end
  end
end

class MockField
  attr_reader :name
  def initialize(name)
    @name = name
  end
end