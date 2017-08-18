require 'rails_helper'

describe ApplicationHelper do
  describe '#step_class' do
    it 'creates CSS class based on current and active step' do
      expect(helper.step_class(1, 2)).to eq 'complete'
      expect(helper.step_class(2, 2)).to eq 'active'
      expect(helper.step_class(2, 1)).to be_nil
    end
  end

  describe '#tooltip' do
    it 'creates a span containing aria label with text and image' do
      tooltip_text = 'foobar'

      html = helper.tooltip(tooltip_text)

      expect(html).to have_css('.hint--top')
      expect(html).to have_selector('img')
      expect(html).to have_xpath("//span[@aria-label='#{tooltip_text}']")
    end
  end

  describe '#session_with_trust?' do
    context 'no user present' do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it 'returns false' do
        expect(helper.session_with_trust?).to eq false
      end

      context 'current path is email confirmation path' do
        it 'returns true' do
          allow(helper).to receive(:current_page?).with(
            controller: 'sign_up/passwords', action: 'new'
          ).and_return(true)

          expect(helper.session_with_trust?).to eq true
        end
      end

      context 'current path is reset password path' do
        it 'returns true' do
          allow(helper).to receive(:current_page?).with(
            controller: 'sign_up/passwords', action: 'new'
          ).and_return(true)
          allow(helper).to receive(:current_page?).with(
            controller: 'users/reset_passwords', action: 'edit'
          ).and_return(true)

          expect(helper.session_with_trust?).to eq true
        end
      end
    end
  end

  describe '#split_tag' do
    context 'receives a string' do
      it 'returns an array delimited at the value given' do
        example_sentence = 'It is cloudy outside today.'
        split = split_tag(example_sentence, 'cloudy')
        expect(split).to eq(['It is ', 'cloudy', ' outside today.'])
      end

      it 'returns the same string if the delimiter is not present' do
        example_sentence = 'It is cloudy outside today.'
        split = split_tag(example_sentence, 'not in set')
        expect(safe_join(split)).to eq(safe_join([example_sentence]))
      end
    end

    context 'receives an array' do
      it 'returns an array delimited at the value given' do
        example_array = ['It is ', 'cloudy', ' outside today.']
        split = split_tag(example_array, 'outside')
        expect(split).to eq(['It is ', 'cloudy', ' outside today.'])
      end

      it 'returns the same array if that delimiter is not present' do
        example_array = ['It is ', 'cloudy', ' outside today.']
        split = split_tag(example_array, 'not in set')
        expect(safe_join(split)).to eq(safe_join(example_array))
      end
    end
  end
end
